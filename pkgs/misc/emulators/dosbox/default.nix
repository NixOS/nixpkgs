{ stdenv, lib, fetchurl, SDL, makeDesktopItem, mesa }:

stdenv.mkDerivation rec {
  name = "dosbox-0.74";

  src = fetchurl {
    url = "mirror://sourceforge/dosbox/${name}.tar.gz";
    sha256 = "01cfjc5bs08m4w79nbxyv7rnvzq2yckmgrbq36njn06lw8b4kxqk";
  };

  patches =
    [ # Fix building with GCC 4.6.
      (fetchurl {
        url = "http://sources.gentoo.org/cgi-bin/viewvc.cgi/gentoo-x86/games-emulation/dosbox/files/dosbox-0.74-gcc46.patch?revision=1.1";
        sha256 = "03iv1ph7fccfw327ngnhvzwyiix7fsbdb5mmpxivzkidhlrssxq9";
      })
      (fetchurl {
        url = "https://svnweb.freebsd.org/ports/head/emulators/dosbox/files/patch-src_gui_sdlmain.cpp?revision=435580&view=co&pathrev=435580";
        sha256 = "1mbj5wrn53k0zds2adys34949vzsbfgm0pmsyx14v9j0cxi7drca";
        name = "patch-src_gui_sdlmain.cpp";
      })
    ];

  patchFlags = "-p0";

  hardeningDisable = [ "format" ];

  buildInputs = [ SDL mesa ];

  configureFlags = lib.optional stdenv.isDarwin "--disable-sdltest";

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

  meta = with lib; {
    homepage = http://www.dosbox.com/;
    description = "A DOS emulator";
    platforms = platforms.unix;
    maintainers = with maintainers; [ matthewbauer ];
    license = licenses.gpl2;
  };
}
