{ stdenv, fetchurl, pkgconfig, tokyocabinet, cairo, pango, ncurses }:

stdenv.mkDerivation rec {
  name = "duc-${version}";
  version = "1.3.3";

  src = fetchurl {
    url = "http://duc.zevv.nl/release/${name}.tar.gz";
    sha256 = "09mp8cq6s43sfhvms4mwhx3lw51vkaxgg34fbfbimafyjh4jdx3k";
  };

  buildInputs = [ pkgconfig tokyocabinet cairo pango ncurses ];

  meta = with stdenv.lib; {
    homepage = http://duc.zevv.nl/;
    description = "Collection of tools for inspecting and visualizing disk usage";
    license = licenses.gpl2;

    platforms = platforms.linux;
    maintainers = [ maintainers.lethalman ];
  };
}
