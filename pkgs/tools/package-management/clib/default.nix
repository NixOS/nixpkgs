{ lib, stdenv, fetchFromGitHub, curl  }:

stdenv.mkDerivation rec {
  version = "2.8.2";
  pname = "clib";

  src = fetchFromGitHub {
    rev    = version;
    owner  = "clibs";
    repo   = "clib";
    sha256 = "sha256-O8elmwH63LU1o2SP+0aovQuhe+QTKOFGjBQ6MAb/6p8=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  buildInputs = [ curl ];

  meta = with lib; {
    description = "C micro-package manager";
    homepage = "https://github.com/clibs/clib";
    license = licenses.mit;
    maintainers = with maintainers; [ jb55 ];
    platforms = platforms.all;
  };
}
