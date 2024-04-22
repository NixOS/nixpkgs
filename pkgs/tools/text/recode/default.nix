{ lib
, stdenv
, fetchurl
, python3Packages
, flex
, texinfo
, libiconv
, libintl
}:

stdenv.mkDerivation rec {
  pname = "recode";
  version = "3.7.14";

  # Use official tarball, avoid need to bootstrap/generate build system
  src = fetchurl {
    url = "https://github.com/rrthomas/${pname}/releases/download/v${version}/${pname}-${version}.tar.gz";
    hash = "sha256-eGqv1USFGisTsKN36sFQD4IM5iYVzMLmMLUB53Q7nzM=";
  };

  nativeBuildInputs = [ python3Packages.python flex texinfo libiconv ];

  buildInputs = [ libintl ];

  enableParallelBuilding = true;

  doCheck = true;

  nativeCheckInputs = with python3Packages; [
    cython
    setuptools
  ];

  meta = {
    homepage = "https://github.com/rrthomas/recode";
    description = "Converts files between various character sets and usages";
    mainProgram = "recode";
    changelog = "https://github.com/rrthomas/recode/raw/v${version}/NEWS";
    platforms = lib.platforms.unix;
    license = with lib.licenses; [ lgpl3Plus gpl3Plus ];
    maintainers = with lib.maintainers; [ jcumming ];
  };
}
