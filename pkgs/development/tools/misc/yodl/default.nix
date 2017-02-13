{ stdenv, fetchFromGitHub, perl, icmake, utillinux }:

stdenv.mkDerivation rec {
  name = "yodl-${version}";
  version = "3.08.02";

  nativeBuildInputs = [ icmake ];

  buildInputs = [ perl ];

  src = fetchFromGitHub {
    sha256 = "0z4pjrl4bq03fxc50c9h0bnc90vqn5c2dy830mjyzjrn1ms3i003";
    rev = version;
    repo = "yodl";
    owner = "fbb-git";
  };

  sourceRoot = "yodl-${version}-src/yodl";

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
