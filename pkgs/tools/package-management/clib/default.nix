{ stdenv, fetchFromGitHub, curl  }:

stdenv.mkDerivation rec {
  version = "1.8.0";
  name = "clib-${version}";

  src = fetchFromGitHub {
    rev    = version;
    owner  = "clibs";
    repo   = "clib";
    sha256 = "0w1qiwq0jjrk8p848bmwxq4wvzhbd2zghq3qm8ylaj3z0xdw7ppk";
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
