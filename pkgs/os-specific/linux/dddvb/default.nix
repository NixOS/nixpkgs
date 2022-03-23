{ lib
, stdenv
, fetchFromGitHub
, kernel
}:

stdenv.mkDerivation rec {
  pname = "dddvb";
  version = "0.9.38-pre.4";

  src = fetchFromGitHub {
    owner = "DigitalDevices";
    repo = "dddvb";
    rev = "e9ccab3578965234c0ea38c5b30969f33600561d";
    sha256 = "sha256-gOG+dAeQ++kTC5xaEpsr3emz3s6FXiKeCHmA9shYBJk=";
  };

  postPatch = ''
    sed -i '/depmod/d' Makefile
  '';

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  INSTALL_MOD_PATH = placeholder "out";

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/DigitalDevices/dddvb";
    description = "ddbridge linux driver";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ hexa ];
    platforms = platforms.linux;
  };
}
