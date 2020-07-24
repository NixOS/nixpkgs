{ stdenv, fetchFromGitHub, curl  }:

stdenv.mkDerivation rec {
  version = "1.11.3";
  pname = "clib";

  src = fetchFromGitHub {
    rev    = version;
    owner  = "clibs";
    repo   = "clib";
    sha256 = "0qwds9w9y2dy39bwh2523wra5dj820cjl11ynkshh7k94fk7qgpm";
  };

  hardeningDisable = [ "fortify" ];

  makeFlags = [ "PREFIX=$(out)" ];

  buildInputs = [ curl ];

  meta = with stdenv.lib; {
    description = "C micro-package manager";
    homepage = "https://github.com/clibs/clib";
    license = licenses.mit;
    maintainers = with maintainers; [ jb55 ];
    platforms = platforms.all;
  };
}
