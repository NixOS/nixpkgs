{ stdenv, fetchurl } :

stdenv.mkDerivation rec {
  name = "bsc-${version}";
  version = "3.1.0";

  src = fetchurl {
    url = "https://github.com/IlyaGrebnov/libbsc/archive/${version}.tar.gz";
    sha256 = "01yhizaf6qjv1plyrx0fcib264maa5qwvgfvvid9rzlzj9fxjib6";
  };

  enableParallelBuilding = true;

  preInstall = ''
    makeFlagsArray+=("PREFIX=$out")
  '';

  meta = with stdenv.lib; {
    description = "High performance block-sorting data compression library";
    homepage = http://libbsc.com/;
    # Later commits changed the licence to Apache2 (no release yet, though)
    license = with licenses; [ lgpl3Plus ];
    platforms = platforms.unix;
  };
}
