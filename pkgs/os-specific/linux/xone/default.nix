{ stdenv, lib, fetchFromGitHub, kernel, fetchurl }:

stdenv.mkDerivation rec {
  pname = "xone";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "medusalix";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-h+j4xCV9R6hp9trsv1NByh9m0UBafOz42ZuYUjclILE=";
  };

  setSourceRoot = ''
    export sourceRoot=$(pwd)/source
  '';

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [
    "-C"
    "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "M=$(sourceRoot)"
    "VERSION=${version}"
  ];

  buildFlags = [ "modules" ];
  installFlags = [ "INSTALL_MOD_PATH=${placeholder "out"}" ];
  installTargets = [ "modules_install" ];

  meta = with lib; {
    description = "Linux kernel driver for Xbox One and Xbox Series X|S accessories";
    homepage = "https://github.com/medusalix/xone";
    license = licenses.gpl2;
    maintainers = with lib.maintainers; [ rhysmdnz ];
    platforms = platforms.linux;
  };
}

