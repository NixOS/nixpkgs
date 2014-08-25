{ stdenv, fetchurl, munge, lua5, libcap, perl, ncurses }:

stdenv.mkDerivation rec {
  name = "diod-${version}";
  version = "1.0.22";

  src = fetchurl {
    url = "https://github.com/chaos/diod/releases/download/${version}/${name}.tar.gz";
    sha256 = "0h92zadbkq4fjhqjzq17cl3x7bdkz2yakpcl0nccv4ml0gwfbx27";
  };

  buildInputs = [ munge lua5 libcap perl ncurses ];

  meta = {
    description = "An I/O forwarding server that implements a variant of the 9P protocol";
    maintainers = [ stdenv.lib.maintainers.rickynils];
    platforms = stdenv.lib.platforms.linux;
  };
}
