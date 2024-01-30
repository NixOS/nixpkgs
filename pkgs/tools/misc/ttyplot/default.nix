{ lib, stdenv, fetchFromGitHub, ncurses, pkg-config }:

stdenv.mkDerivation rec {
  pname = "ttyplot";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "tenox7";
    repo = "ttyplot";
    rev = version;
    hash = "sha256-HBJvTDhp1CA96gRU2Q+lMxcFaZ+txXcmNb8Cg1BFiH4=";
  };

  buildInputs = [
    pkg-config
    ncurses
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "A simple general purpose plotting utility for tty with data input from stdin";
    homepage = "https://github.com/tenox7/ttyplot";
    license = licenses.asl20;
    maintainers = with maintainers; [ lassulus ];
    mainProgram = "ttyplot";
  };
}
