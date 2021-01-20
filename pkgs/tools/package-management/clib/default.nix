{ lib, stdenv, fetchFromGitHub, curl  }:

stdenv.mkDerivation rec {
  version = "1.11.4";
  pname = "clib";

  src = fetchFromGitHub {
    rev    = version;
    owner  = "clibs";
    repo   = "clib";
    sha256 = "0cxldyx5bsld8gdasqpqlnzyap294hlkgcjyw3vlzlxcb0izjy8i";
  };

  hardeningDisable = [ "fortify" ];

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
