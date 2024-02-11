{ stdenv, lib, fetchFromGitHub, kernel, fetchurl, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "xone";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "medusalix";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-h+j4xCV9R6hp9trsv1NByh9m0UBafOz42ZuYUjclILE=";
  };

  patches = [
    # Fix build on kernel 6.3
    (fetchpatch {
      name = "kernel-6.3.patch";
      url = "https://github.com/medusalix/xone/commit/bbf0dcc484c3f5611f4e375da43e0e0ef08f3d18.patch";
      hash = "sha256-A2OzRRk4XT++rS6k6EIyiPy/LJptvVRUxoP7CIGrPWU=";
    })
  ];

  setSourceRoot = ''
    export sourceRoot=$(pwd)/${src.name}
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

