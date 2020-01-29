{ stdenv, fetchFromGitHub, curl  }:

stdenv.mkDerivation rec {
  version = "1.11.2";
  pname = "clib";

  src = fetchFromGitHub {
    rev    = version;
    owner  = "clibs";
    repo   = "clib";
    sha256 = "03q5l873zc1dm478f35ibqandypakf47hzqb5gjpnpbcyb2m2jxz";
  };

  hardeningDisable = [ "fortify" ];

  makeFlags = [ "PREFIX=$(out)" ];

  buildInputs = [ curl ];

  meta = with stdenv.lib; {
    description = "C micro-package manager";
    homepage = https://github.com/clibs/clib;
    license = licenses.mit;
    maintainers = with maintainers; [ jb55 ];
    platforms = platforms.all;
  };
}
