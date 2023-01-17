{ lib, stdenv, fetchurl, ncurses, xmlto }:

stdenv.mkDerivation rec {

  pname = "galaxis";
  version = "1.10";

  src = fetchurl{
    url = "http://www.catb.org/~esr/galaxis/${pname}-${version}.tar.gz";
    sha256 = "1181x3z4r0794v2bkpigb5fablw1nayj42wvhy2am79p7j1iqq5r";
  };

  buildInputs = [ ncurses xmlto ];

  patchPhase = ''
    sed -i\
     -e 's|^install: galaxis\.6 uninstall|install: galaxis.6|'\
     -e 's|usr/||g' -e 's|ROOT|DESTDIR|g'\
     -e 's|install -m 755 -o 0 -g 0|install -m 755|' Makefile
  '';

  dontConfigure = true;

  makeFlags = [ "DESTDIR=$(out)" ];

  meta = with lib; {
    description = "Rescue lifeboats lost in interstellar space";
    longDescription = ''
      Lifeboats from a crippled interstellar liner are adrift in a starfield. To
      find them, you can place probes that look in all eight compass directions
      and tell you how many lifeboats they see. If you drop a probe directly on
      a lifeboat it will be revealed immediately. Your objective: find the
      lifeboats as quickly as possible, before the stranded passengers run out
      of oxygen!

      This is a UNIX-hosted, curses-based clone of the nifty little Macintosh
      freeware game Galaxis. It doesn't have the super-simple, point-and-click
      interface of the original, but compensates by automating away some of the
      game's simpler deductions.
    '';
    homepage = "http://catb.org/~esr/galaxis/";
    license = licenses.gpl2;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
