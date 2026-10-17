{
  lib,
  stdenv,
  kernel,
  kernelModuleMakeFlags,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "new-lg4ff";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "berarma";
    repo = "new-lg4ff";
    tag = "v${version}";
    sha256 = "sha256-nh5J89S3z0odzh2fDsAVVY1X6lr4ZUwoyu3UVOYQiq8=";
  };

  preBuild = ''
    substituteInPlace Makefile --replace-fail "modules_install" "INSTALL_MOD_PATH=$out modules_install"
    sed -i '/depmod/d' Makefile
    sed -i "10i\\\trmmod hid-logitech 2> /dev/null || true" Makefile
    sed -i "11i\\\trmmod hid-logitech-new 2> /dev/null || true" Makefile
  '';

  nativeBuildInputs = kernel.moduleBuildDependencies;

  preConfigure = ''
    makeFlagsArray+=(
      KVERSION="${kernel.modDirVersion}"
      KDIR="${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
      KCFLAGS="-DCONFIG_LOGIWHEELS_FF -DCONFIG_LEDS_CLASS"
      ${builtins.concatStringsSep " " kernelModuleMakeFlags}
    )
  '';

  meta = {
    description = "Experimental Logitech force feedback module for Linux";
    homepage = "https://github.com/berarma/new-lg4ff";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      amadejkastelic
      matthiasbenaets
    ];
    platforms = lib.platforms.linux;
    broken = stdenv.hostPlatform.isAarch64;
  };
}
