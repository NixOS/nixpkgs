{ stdenv, fetchurl, perl, icmake }:

stdenv.mkDerivation rec {
  name = "yodl-${version}";
  version = "3.04.00";

  buildInputs = [ perl icmake ];

  src = fetchurl {
    url = "mirror://sourceforge/yodl/yodl_${version}.orig.tar.gz";
    sha256 = "14sqd03j3w9g5l5rkdnqyxv174yz38m39ycncx86bq86g63igcv6";
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
