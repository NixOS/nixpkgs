{ lib, stdenv, fetchFromGitHub, ncurses }:

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

  meta = with lib; {
    homepage = "https://github.com/bderrly/braincurses";
    description = "Version of the classic game Mastermind";
    mainProgram = "braincurses";
    license = licenses.gpl2;
    maintainers = with maintainers; [ dotlambda ];
    platforms = platforms.linux;
  };
}
