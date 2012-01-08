{fetchurl, stdenv, ncurses}:

let
  name = "htop-1.0";
in
stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "mirror://sourceforge/htop/${name}.tar.gz";
    sha256 = "242879b86db4b97e1090e7cd391247268ccbe90834ff34b6e8242926c9664852";
  };

  buildInputs = [ncurses];

  meta = {
    description = "An interactive process viewer for Linux";
    homepage = "http://htop.sourceforge.net";
    platforms = stdenv.lib.platforms.linux;
  };
}
