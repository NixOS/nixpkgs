{fetchurl, stdenv, ncurses}:

stdenv.mkDerivation rec {
  name = "htop-0.8.3";
  src = fetchurl {
    url = "mirror://sourceforge/htop/${name}.tar.gz";
    sha256 = "f03bac8999c57c399cbf4332831bcce905d0393d0f97f7e32a1407b48890dd9d";
  };
  buildInputs = [ncurses];
  meta = {
    description = "An interactive process viewer for Linux";
    homepage = "http://htop.sourceforge.net";
    platforms = stdenv.lib.platforms.linux;
  };
}
