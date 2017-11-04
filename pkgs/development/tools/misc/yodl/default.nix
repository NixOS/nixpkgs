{ stdenv, fetchFromGitHub, perl, icmake, utillinux }:

stdenv.mkDerivation rec {
  name = "yodl-${version}";
  version = "4.01.00";

  nativeBuildInputs = [ icmake ];

  buildInputs = [ perl ];

  src = fetchFromGitHub {
    sha256 = "1aahwmj4gmf59lrij2373lkgfj77i3ghdas9c7iqrjwaizb0430p";
    rev = version;
    repo = "yodl";
    owner = "fbb-git";
  };

  setSourceRoot = ''
    sourceRoot=$(echo */yodl)
  '';

  preConfigure = ''
    patchShebangs ./build
    patchShebangs scripts/
    substituteInPlace INSTALL.im --replace /usr $out
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
    homepage = https://fbb-git.github.io/yodl/;
    license = licenses.gpl3;
    maintainers = with maintainers; [ nckx pSub ];
    platforms = platforms.linux;
  };
}
