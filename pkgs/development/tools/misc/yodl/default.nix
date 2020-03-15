{ stdenv, fetchFromGitLab, perl, icmake, utillinux }:

stdenv.mkDerivation rec {
  pname = "yodl";
  version = "4.02.02";

  nativeBuildInputs = [ icmake ];

  buildInputs = [ perl ];

  src = fetchFromGitLab {
    sha256 = "1kf4h99p9i35fgas8z5wdy2qpd7gqfd645b5z7mfssjzsfdrv745";
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
    homepage = https://fbb-git.gitlab.io/yodl/;
    license = licenses.gpl3;
    maintainers = with maintainers; [ pSub ];
    platforms = platforms.linux;
  };
}
