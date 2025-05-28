{
  lib,
  stdenv,
  kernel,
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

  makeFlags = [
    "KVERSION=${kernel.modDirVersion}"
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    # Fake the CONFIG_LOGIWHEELS_FF config option, so it builds for 6.15
    "KCFLAGS=-DCONFIG_LOGIWHEELS_FF"
  ];

  meta = with lib; {
    description = "Experimental Logitech force feedback module for Linux";
    homepage = "https://github.com/berarma/new-lg4ff";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ matthiasbenaets ];
    platforms = platforms.linux;
    broken = stdenv.hostPlatform.isAarch64;
  };
}
