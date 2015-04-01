{ stdenv, fetchurl, perl, icmake }:

stdenv.mkDerivation rec {
  name = "yodl-${version}";
  version = "3.05.00";

  buildInputs = [ perl icmake ];

  src = fetchurl {
    url = "mirror://sourceforge/yodl/yodl_${version}.orig.tar.gz";
    sha256 = "12hv5ghrsk6kdi414glg888v3qk3m1nmicl8f0h5k4szm1i00dig";
  };

  preConfigure = ''
    patchShebangs scripts/.
    sed -i 's;/usr;;g' INSTALL.im
    substituteInPlace build --replace /usr/bin/icmake ${icmake}/bin/icmake
    substituteInPlace macros/rawmacros/startdoc.pl --replace /usr/bin/perl ${perl}/bin/perl
  '';

  buildPhase = ''
    ./build programs
    ./build macros
    ./build man
  '';

  installPhase = ''
    ./build install programs $out
    ./build install macros $out
    ./build install man $out
  '';

  meta = with stdenv.lib; {
    description = "A package that implements a pre-document language and tools to process it";
    homepage = http://yodl.sourceforge.net/;
    license = licenses.gpl3;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
  };
}
