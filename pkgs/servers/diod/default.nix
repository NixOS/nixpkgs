{ stdenv, fetchurl, munge, lua5, libcap, perl, ncurses }:

stdenv.mkDerivation rec {
  name = "diod-${version}";
  version = "1.0.21";

  src = fetchurl {
    url = "https://github.com/chaos/diod/archive/${version}.tar.gz";
    sha256 = "1864i42a4rm3f1q68nc19kcshc0hcf6zfgsdq0ppmmwry4mrvij0";
  };

  buildInputs = [ munge lua5 libcap perl ncurses ];

  meta = {
    description = "An I/O forwarding server that implements a variant of the 9P protocol";
    maintainers = [ stdenv.lib.maintainers.rickynils];
    platforms = stdenv.lib.platforms.linux;
  };
}
