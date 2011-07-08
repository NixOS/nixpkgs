{fetchurl, stdenv, ncurses}:

let
  name = "htop-0.9";
in
stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "mirror://sourceforge/htop/${name}.tar.gz";
    sha256 = "4de65c38e1886bccd30ed692b30eb9bf195240680781bfe1eaf5faf84ee6fbfd";
  };

  buildInputs = [ncurses];

  meta = {
    description = "An interactive process viewer for Linux";
    homepage = "http://htop.sourceforge.net";
    platforms = stdenv.lib.platforms.linux;
  };
}
