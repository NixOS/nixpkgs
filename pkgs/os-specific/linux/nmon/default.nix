{ fetchurl, lib, stdenv, ncurses }:

stdenv.mkDerivation rec {
  pname = "nmon";
  version = "16m";

  src = fetchurl {
    url = "mirror://sourceforge/nmon/lmon${version}.c";
    sha256 = "1hazgrq3m01dzv05639yis1mypcp0jf167n9gqwd3wgxzm2lvv9b";
  };

  buildInputs = [ ncurses ];
  dontUnpack = true;
  buildPhase = "cc -o nmon ${src} -g -O2 -D JFS -D GETUSER -Wall -D LARGEMEM -lncurses -lm -g -D X86";
  installPhase = ''
    mkdir -p $out/bin
    cp nmon $out/bin
  '';

  meta = with lib; {
    description = "AIX & Linux Performance Monitoring tool";
    homepage = "http://nmon.sourceforge.net";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ sveitser ];
  };
}
