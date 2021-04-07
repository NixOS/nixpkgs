{ lib, stdenv, fetchurl, openmp ? null }:

stdenv.mkDerivation rec {
  pname = "bsc";
  version = "3.1.0";

  src = fetchurl {
    url = "https://github.com/IlyaGrebnov/libbsc/archive/${version}.tar.gz";
    sha256 = "01yhizaf6qjv1plyrx0fcib264maa5qwvgfvvid9rzlzj9fxjib6";
  };

  enableParallelBuilding = true;

  buildInputs = lib.optional stdenv.isDarwin openmp;

  prePatch = ''
    substituteInPlace makefile \
        --replace 'g++' '$(CXX)'
  '';

  preInstall = ''
    makeFlagsArray+=("PREFIX=$out")
  '';

  meta = with lib; {
    description = "High performance block-sorting data compression library";
    homepage = "http://libbsc.com/";
    # Later commits changed the licence to Apache2 (no release yet, though)
    license = with licenses; [ lgpl3Plus ];
    platforms = platforms.unix;
  };
}
