{ fetchurl, stdenv, ncurses }:

stdenv.mkDerivation rec {
  name = "htop-1.0.2";

  src = fetchurl {
    url = "mirror://sourceforge/htop/${name}.tar.gz";
    sha256 = "18fqrhvnm7h4c3939av8lpiwrwxbyw6hcly0jvq0vkjf0ixnaq7f";
  };

  buildInputs = [ ncurses ];

  meta = {
    description = "An interactive process viewer for Linux";
    homepage = "http://htop.sourceforge.net";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.rob stdenv.lib.maintainers.simons ];
  };
}
