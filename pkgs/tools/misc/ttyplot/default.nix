{ lib, stdenv, fetchFromGitHub, ncurses, pkg-config }:

stdenv.mkDerivation rec {
  pname = "ttyplot";
  version = "1.6.5";

  src = fetchFromGitHub {
    owner = "tenox7";
    repo = "ttyplot";
    rev = version;
    hash = "sha256-DLFEnEo+EQuq4ziqo9qfyHGD1Zosk9Kb/80QjnI2aXk=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    ncurses
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Simple general purpose plotting utility for tty with data input from stdin";
    homepage = "https://github.com/tenox7/ttyplot";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ lassulus ];
    mainProgram = "ttyplot";
  };
}
