{ stdenv, lib, fetchurl, makeDesktopItem, SDL, SDL_net, SDL_sound, libGLU_combined, libpng }:

stdenv.mkDerivation rec {
  name = "dosbox-0.74-2";

  src = fetchurl {
    url = "mirror://sourceforge/dosbox/${name}.tar.gz";
    sha256 = "1ksp1b5szi0vy4x55rm3j1y9wq5mlslpy8llpg87rpdyjlsk0xvh";
  };

  hardeningDisable = [ "format" ];

  buildInputs = [ SDL SDL_net SDL_sound libGLU_combined libpng ];

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

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = http://www.dosbox.com/;
    description = "A DOS emulator";
    platforms = platforms.unix;
    maintainers = with maintainers; [ matthewbauer ];
    license = licenses.gpl2;
  };
}
