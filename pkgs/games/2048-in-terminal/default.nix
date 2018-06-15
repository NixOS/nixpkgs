{ stdenv, fetchFromGitHub, ncurses }:

stdenv.mkDerivation rec {
  name = "2048-in-terminal-${version}";
  version = "2017-11-29";

  src = fetchFromGitHub {
    sha256 = "1cqv5z1i5zcrvj0w6pdfnnff8m6kjndqxwkwsw5ma9jz503bmyc6";
    rev = "4e525066b0ef3442e92d2ba8dd373bdc205ece28";
    repo = "2048-in-terminal";
    owner = "alewmoose";
  };

  buildInputs = [ ncurses ];

  prePatch = ''
    sed -i '1i#include <fcntl.h>\n' save.c
  '';

  enableParallelBuilding = true;

  preInstall = ''
    mkdir -p $out/bin
  '';
  installFlags = [ "DESTDIR=$(out)/bin" ];

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Animated console version of the 2048 game";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
