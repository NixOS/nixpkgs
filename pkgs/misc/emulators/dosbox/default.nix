{ stdenv, fetchurl, fetchsvn, SDL, SDL_net, SDL_sound, libpng, makeDesktopItem, mesa, autoreconfHook }:

let revision = "4024";
in stdenv.mkDerivation rec {
  name = "dosbox-0.74-${revision}";

  src = fetchsvn {
    url = "https://dosbox.svn.sourceforge.net/svnroot/dosbox/dosbox/trunk";
    rev = revision;
    sha256 = "16s6xwmz7992l0kg6cj9aqk21cc0p6c0dn0x0sx5iadbbll7ma6p";
  };

  patches =
    [ # Fix building with GCC 4.6.
      (fetchurl {
        url = "http://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo-x86/games-emulation/dosbox/files/dosbox-0.74-gcc46.patch?revision=1.1";
        sha256 = "03iv1ph7fccfw327ngnhvzwyiix7fsbdb5mmpxivzkidhlrssxq9";
      })
    ];

  patchFlags = "-p0";

  hardeningDisable = [ "format" ];

  buildInputs = [ SDL SDL_net SDL_sound libpng mesa autoreconfHook ];

  desktopItem = makeDesktopItem {
    name = "dosbox";
    exec = "dosbox";
    comment = "x86 emulator with internal DOS";
    desktopName = "DOSBox";
    genericName = "DOS emulator";
    categories = "Application;Emulator;";
  };

  postInstall = ''
     mkdir -p $out/share/applications
     cp ${desktopItem}/share/applications/* $out/share/applications
  '';

  meta = {
    homepage = http://www.dosbox.com/;
    description = "A DOS emulator";
    platforms = stdenv.lib.platforms.unix;
  };
}
