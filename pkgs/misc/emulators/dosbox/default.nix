{ stdenv, fetchurl, SDL, makeDesktopItem }:

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
    ];

  patchFlags = "-p0";
  
  buildInputs = [ SDL ];
    
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
  };
}
