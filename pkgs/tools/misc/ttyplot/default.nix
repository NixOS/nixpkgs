{ lib, stdenv, fetchFromGitHub, ncurses }:

stdenv.mkDerivation rec {
  pname = "ttyplot";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "tenox7";
    repo = "ttyplot";
    rev = version;
    sha256 = "sha256-BYMdGNDl8HUin1Hu4Fqgx305a/tTt1fztqlT2vDeTh8=";
  };

  buildInputs = [ ncurses ];

  buildPhase = ''
   ${stdenv.cc}/bin/cc ./ttyplot.c -lncurses -o ttyplot
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp ttyplot $out/bin/
  '';

  meta = with lib; {
    description = "A simple general purpose plotting utility for tty with data input from stdin";
    homepage = "https://github.com/tenox7/ttyplot";
    license = licenses.unlicense;
    maintainers = with maintainers; [ lassulus ];
    mainProgram = "ttyplot";
  };
}
