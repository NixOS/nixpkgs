{
  lib,
  stdenv,
  kernel,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "new-lg4ff";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "berarma";
    repo = "new-lg4ff";
    rev = version;
    sha256 = "ZFwNdeJcSxzWtqjOF86SZpqhuz8jXZ2drvlQeIqsaNY=";
  };

  preBuild = ''
    substituteInPlace Makefile --replace "modules_install" "INSTALL_MOD_PATH=$out modules_install"
    sed -i '/depmod/d' Makefile
    sed -i "10i\\\trmmod hid-logitech 2> /dev/null || true" Makefile
    sed -i "11i\\\trmmod hid-logitech-new 2> /dev/null || true" Makefile
  '';

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [
    "KVERSION=${kernel.modDirVersion}"
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  meta = with lib; {
    description = "Experimental Logitech force feedback module for Linux";
    homepage = "https://github.com/berarma/new-lg4ff";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ matthiasbenaets ];
    platforms = platforms.linux;
    broken = stdenv.isAarch64;
  };
}
