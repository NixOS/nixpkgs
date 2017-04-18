{ stdenv, fetchurl, SDL, makeDesktopItem, mesa }:

stdenv.mkDerivation rec { 
  name = "dosbox-0.74";

  src = fetchurl {
    url = "mirror://sourceforge/dosbox/${name}.tar.gz";
    sha256 = "01cfjc5bs08m4w79nbxyv7rnvzq2yckmgrbq36njn06lw8b4kxqk";
  };

  patches =
    [ # Fix building with GCC 4.6+.
      ./gcc46+.patch
    ];

  patchFlags = "-p0";

  hardeningDisable = [ "format" ];

  buildInputs = [ SDL mesa ];

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
