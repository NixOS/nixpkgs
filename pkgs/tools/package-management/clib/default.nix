{ stdenv, fetchFromGitHub, curl  }:

stdenv.mkDerivation rec {
  version = "1.8.1";
  name = "clib-${version}";

  src = fetchFromGitHub {
    rev    = version;
    owner  = "clibs";
    repo   = "clib";
    sha256 = "1kl8amlw0106jsvv71a7nifhff1jdvgsrxr7l7hfr75i506q8976";
  };

  hardeningDisable = [ "fortify" ];

  makeFlags = "PREFIX=$(out)";

  buildInputs = [ curl ];

  meta = with stdenv.lib; {
    description = "C micro-package manager";
    homepage = https://github.com/clibs/clib;
    license = licenses.mit;
    maintainers = with maintainers; [ jb55 ];
    platforms = platforms.all;
  };
}
