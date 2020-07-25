{ stdenv, fetchFromGitHub, ncurses }:

stdenv.mkDerivation rec {
  pname = "braincurses";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "bderrly";
    repo = "braincurses";
    rev = version;
    sha256 = "0gpny9wrb0zj3lr7iarlgn9j4367awj09v3hhxz9r9a6yhk4anf5";
  };

  buildInputs = [ ncurses ];

  # There is no install target in the Makefile
  installPhase = ''
    install -Dt $out/bin braincurses
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/bderrly/braincurses";
    description = "A version of the classic game Mastermind";
    license = licenses.gpl2;
    maintainers = with maintainers; [ dotlambda ];
    platforms = platforms.linux;
  };
}
