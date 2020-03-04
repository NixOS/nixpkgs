{ stdenv, fetchurl, ncurses, xmlto }:

with stdenv.lib;
stdenv.mkDerivation rec{

  pname = "vms-empire";
  version = "1.15";

  src = fetchurl{
    url = "http://www.catb.org/~esr/vms-empire/${pname}-${version}.tar.gz";
    sha256 = "1vcpglkimcljb8s1dp6lzr5a0vbfxmh6xf37cmb8rf9wc3pghgn3";
  };

  buildInputs =
  [ ncurses xmlto ];

  patchPhase = ''
    sed -i -e 's|^install: empire\.6 uninstall|install: empire.6|' -e 's|usr/||g' Makefile
  '';

  hardeningDisable = [ "format" ];

  makeFlags = [ "DESTDIR=$(out)" ];

  meta = {
    description = "The ancestor of all expand/explore/exploit/exterminate games";
    longDescription = ''
      Empire is a simulation of a full-scale war between two emperors, the
      computer and you. Naturally, there is only room for one, so the object of
      the game is to destroy the other. The computer plays by the same rules
      that you do. This game was ancestral to all later
      expand/explore/exploit/exterminate games, including Civilization and
      Master of Orion.
    '';
    homepage = http://catb.org/~esr/vms-empire/;
    license = licenses.gpl2;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}


