{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  name = "dvtm-0.15";

  meta = {
    description = "Dynamic virtual terminal manager";
    homepage = http://www.brain-dump.org/projects/dvtm;
    license = stdenv.lib.licenses.mit;
    platfroms = stdenv.lib.platforms.linux;
  };

  src = fetchurl {
    url = "${meta.homepage}/${name}.tar.gz";
    sha256 = "0475w514b7i3gxk6khy8pfj2gx9l7lv2pwacmq92zn1abv01a84g";
  };

  buildInputs = [ ncurses ];

  prePatch = ''
    substituteInPlace Makefile \
      --replace /usr/share/terminfo $out/share/terminfo
  '';

  installPhase = ''
    make PREFIX=$out install
  '';
}
