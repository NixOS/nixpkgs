{ stdenv, fetchurl, perl, icmake, utillinux }:

stdenv.mkDerivation rec {
  name = "yodl-${version}";
  version = "3.05.01";

  buildInputs = [ perl icmake ];

  src = fetchurl {
    url = "mirror://sourceforge/yodl/yodl_${version}.orig.tar.gz";
    sha256 = "0ghdzr3lzgfzvfymnjbj4mw8vpq098swvipxghhqgfmv58dhwgas";
  };

  preConfigure = ''
    patchShebangs scripts/.
    substituteInPlace INSTALL.im --replace /usr $out
    patchShebangs ./build
    substituteInPlace macros/rawmacros/startdoc.pl --replace /usr/bin/perl ${perl}/bin/perl
    substituteInPlace scripts/yodl2whatever.in --replace getopt ${utillinux}/bin/getopt
  '';

  buildPhase = ''
    ./build programs
    ./build macros
    ./build man
  '';

  installPhase = ''
    ./build install programs
    ./build install macros
    ./build install man
  '';

  meta = with stdenv.lib; {
    description = "A package that implements a pre-document language and tools to process it";
    homepage = http://yodl.sourceforge.net/;
    license = licenses.gpl3;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
  };
}
