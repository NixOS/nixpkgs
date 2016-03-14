{ fetchurl, stdenv, autoreconfHook, ncurses }:

stdenv.mkDerivation rec {
  name = "htop-${version}";
  version = "2.0.1";

  src = fetchurl {
    url = "http://hisham.hm/htop/releases/${version}/${name}.tar.gz";
    sha256 = "0rjn9ybqx5sav7z4gn18f1q6k23nmqyb6yydfgghzdznz9nn447l";
  };

  buildInputs = [ ncurses ];
  nativeBuildInputs = [ autoreconfHook ];

  postPatch = ''
    touch *.h */*.h # unnecessary regeneration requires Python
  '';

  meta = {
    description = "An interactive process viewer for Linux";
    homepage = "http://htop.sourceforge.net";
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ rob simons relrod ];
  };
}
