{ lib, stdenv, fetchFromGitHub, curl  }:

stdenv.mkDerivation rec {
  version = "2.8.3";
  pname = "clib";

  src = fetchFromGitHub {
    rev    = version;
    owner  = "clibs";
    repo   = "clib";
    sha256 = "sha256-Ld6u+F25SOyYr+JWXVmn5G8grQ39eN8EY7j77WNycEE=";
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
