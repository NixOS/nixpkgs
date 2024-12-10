{
  lib,
  stdenv,
  fetchFromGitLab,
  perl,
  icmake,
  util-linux,
}:

stdenv.mkDerivation rec {
  pname = "yodl";
  version = "4.03.03";

  nativeBuildInputs = [ icmake ];

  buildInputs = [ perl ];

  src = fetchFromGitLab {
    sha256 = "sha256-MeD/jjhwoiWTb/G8pHrnEEX22h+entPr9MhJ6WHO3DM=";
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
    substituteInPlace scripts/yodl2whatever.in --replace getopt ${util-linux}/bin/getopt
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

  meta = with lib; {
    description = "A package that implements a pre-document language and tools to process it";
    homepage = "https://fbb-git.gitlab.io/yodl/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
  };
}
