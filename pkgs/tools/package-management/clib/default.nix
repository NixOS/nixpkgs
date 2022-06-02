{ lib, stdenv, fetchFromGitHub, curl  }:

stdenv.mkDerivation rec {
  version = "2.8.1";
  pname = "clib";

  src = fetchFromGitHub {
    rev    = version;
    owner  = "clibs";
    repo   = "clib";
    sha256 = "sha256-AzPpGwtZemKX2r/XKyNTJ+lVwU1QUxkB2OywtCwTAWs=";
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
