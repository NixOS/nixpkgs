{ stdenv, fetchurl, munge, lua, libcap, perl, ncurses }:

stdenv.mkDerivation rec {
  name = "diod-${version}";
  version = "1.0.24";

  src = fetchurl {
    url = "https://github.com/chaos/diod/releases/download/${version}/${name}.tar.gz";
    sha256 = "17wckwfsqj61yixz53nwkc35z66arb1x3napahpi64m7q68jn7gl";
  };

  buildInputs = [ munge lua libcap perl ncurses ];

  meta = {
    description = "An I/O forwarding server that implements a variant of the 9P protocol";
    maintainers = [ stdenv.lib.maintainers.rickynils];
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
