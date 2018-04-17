{ fetchurl, stdenv, ncurses }:

stdenv.mkDerivation rec {
  name = "nmon-${version}";
  version = "16g";

  src = fetchurl {
    url = "mirror://sourceforge/nmon/lmon${version}.c";
    sha256 = "127n8xvmg7byp42sm924mdr7hd3bsfsxpryzahl0cfsh7dlxv0ns";
  };

  buildInputs = [ ncurses ];
  unpackPhase = ":";
  buildPhase = "cc -o nmon ${src} -g -O2 -D JFS -D GETUSER -Wall -D LARGEMEM -lncurses -lm -g -D X86";
  installPhase = ''
    mkdir -p $out/bin
    cp nmon $out/bin
  '';

  meta = with stdenv.lib; {
    description = "AIX & Linux Performance Monitoring tool";
    homepage = "http://nmon.sourceforge.net";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ sveitser ];
  };
}
