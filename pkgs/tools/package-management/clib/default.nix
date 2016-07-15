{ stdenv, fetchFromGitHub, curl  }:

stdenv.mkDerivation rec {
  version = "1.7.0";
  name = "clib-${version}";

  src = fetchFromGitHub {
    rev    = version;
    owner  = "clibs";
    repo   = "clib";
    sha256 = "08n2i3dyh5vnrb74a6wlqqn67c9nwkq0v0v651zzha495mqbciq7";
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
