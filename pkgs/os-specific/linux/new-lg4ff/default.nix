{
  lib,
  stdenv,
  kernel,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "new-lg4ff";
  version = "0-unstable-2025-05-28";

  src = fetchFromGitHub {
    owner = "berarma";
    repo = "new-lg4ff";
    rev = "2092db19f7b40854e0427a1b2e39eda9f8d0c3cd";
    sha256 = "sha256-nh5J89S3z0odzh2fDsAVVY1X6lr4ZUwoyu3UVOYQiq8=";
  };

  preBuild = ''
    substituteInPlace Makefile --replace-fail "modules_install" "INSTALL_MOD_PATH=$out modules_install"
    sed -i '/depmod/d' Makefile
    sed -i "10i\\\trmmod hid-logitech 2> /dev/null || true" Makefile
    sed -i "11i\\\trmmod hid-logitech-new 2> /dev/null || true" Makefile

    # Fake the CONFIG_LOGIWHEELS_FF config option, so it builds for 6.15
    sed -i '1i\#ifndef CONFIG_LOGIWHEELS_FF\n#define CONFIG_LOGIWHEELS_FF 1\n#endif' hid-lg4ff.c
    sed -i '1i\#ifndef CONFIG_LOGIWHEELS_FF\n#define CONFIG_LOGIWHEELS_FF 1\n#endif' hid-lg.c
  '';

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [
    "KVERSION=${kernel.modDirVersion}"
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  meta = {
    description = "Experimental Logitech force feedback module for Linux";
    homepage = "https://github.com/berarma/new-lg4ff";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ matthiasbenaets ];
    platforms = lib.platforms.linux;
    broken = stdenv.hostPlatform.isAarch64;
  };
}
