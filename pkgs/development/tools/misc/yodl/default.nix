{ stdenv, fetchFromGitHub, perl, icmake, utillinux }:

stdenv.mkDerivation rec {
  name = "yodl-${version}";
  version = "4.02.00";

  nativeBuildInputs = [ icmake ];

  buildInputs = [ perl ];

  src = fetchFromGitHub {
    sha256 = "08i3q3h581kxr5v7wi114bng66pwwsjs5qj3ywnnrr7ra1h5rzwa";
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

  # Set TERM because icmbuild calls tput.
  TERM = "xterm";

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
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
  };
}
