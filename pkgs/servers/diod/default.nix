{ stdenv, fetchurl, munge, lua, libcap, perl, ncurses }:

stdenv.mkDerivation rec {
  name = "diod-${version}";
  version = "1.0.23";

  src = fetchurl {
    url = "https://github.com/chaos/diod/releases/download/${version}/${name}.tar.gz";
    sha256 = "002vxc9fwdwshda4jydxagr63xd6nnhbc6fh73974gi2pvp6gid3";
  };

  buildInputs = [ munge lua libcap perl ncurses ];

  meta = {
    description = "An I/O forwarding server that implements a variant of the 9P protocol";
    maintainers = [ stdenv.lib.maintainers.rickynils];
    platforms = stdenv.lib.platforms.linux;
  };
}
