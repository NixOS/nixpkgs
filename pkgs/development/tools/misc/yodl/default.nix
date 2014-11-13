{ stdenv, fetchurl, perl, icmake }:

stdenv.mkDerivation rec {
  name = "yodl-${version}";
  version = "3.03.0";

  buildInputs = [ perl icmake ];

  src = fetchurl {
    url = "mirror://sourceforge/yodl/yodl_${version}.orig.tar.gz";
    sha256 = "1gqlhal41fy5x2hs24j3nl8q9vrmdbpj4pdx73a6dln66kx8jgnk";
  };

  preConfigure = ''
    patchShebangs scripts/.
    sed -i 's;/usr;;g' INSTALL.im
    substituteInPlace build --replace /usr/bin/icmake ${icmake}/bin/icmake
    substituteInPlace macros/rawmacros/startdoc.pl --replace /usr/bin/perl ${perl}/bin/perl
  '';

  buildPhase = ''
    ./build programs
    ./build man
    ./build macros
  '';

  installPhase = ''
    ./build install programs $out
    ./build install man $out
    ./build install macros $out
  '';

  meta = with stdenv.lib; {
    description = "A package that implements a pre-document language and tools to process it";
    homepage = http://yodl.sourceforge.net/;
    license = licenses.gpl3;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
  };
}
