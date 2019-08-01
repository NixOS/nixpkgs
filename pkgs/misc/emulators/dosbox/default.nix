{ stdenv, lib, fetchurl, makeDesktopItem, SDL, SDL_net, SDL_sound, libGLU_combined, libpng, graphicsmagick }:

stdenv.mkDerivation rec {
  name = "dosbox-0.74-3";

  src = fetchurl {
    url = "mirror://sourceforge/dosbox/${name}.tar.gz";
    sha256 = "02i648i50dwicv1vaql15rccv4g8h5blf5g6inv67lrfxpbkvlf0";
  };

  hardeningDisable = [ "format" ];

  buildInputs = [ SDL SDL_net SDL_sound libGLU_combined libpng ];

  nativeBuildInputs = [ graphicsmagick ];

  configureFlags = lib.optional stdenv.isDarwin "--disable-sdltest";

  desktopItem = makeDesktopItem {
    name = "dosbox";
    exec = "dosbox";
    icon = "dosbox";
    comment = "x86 emulator with internal DOS";
    desktopName = "DOSBox";
    genericName = "DOS emulator";
    categories = "Application;Emulator;";
  };

  postInstall = ''
     mkdir -p $out/share/applications
     cp ${desktopItem}/share/applications/* $out/share/applications

     mkdir -p $out/share/icons/hicolor/256x256/apps
     gm convert src/dosbox.ico $out/share/icons/hicolor/256x256/apps/dosbox.png
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = http://www.dosbox.com/;
    description = "A DOS emulator";
    platforms = platforms.unix;
    maintainers = with maintainers; [ matthewbauer ];
    license = licenses.gpl2;
  };
}
