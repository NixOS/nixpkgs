{ stdenv, lib, fetchurl, makeDesktopItem, SDL, SDL_net, SDL_sound, libGLU_combined, libpng, fetchpatch }:

stdenv.mkDerivation rec {
  name = "dosbox-0.74-2";

  src = fetchurl {
    url = "mirror://sourceforge/dosbox/${name}.tar.gz";
    sha256 = "1ksp1b5szi0vy4x55rm3j1y9wq5mlslpy8llpg87rpdyjlsk0xvh";
  };

  patches = [
    (fetchpatch {
      name = "cve-2019-7165.patch";
      url = "https://salsa.debian.org/debian/dosbox/raw/30989a35ee478f8f4bc8e167fccbf92fc77e1519/debian/patches/cve-2019-7165.patch?inline=false";
      sha256 = "12c2wq6l62x9iggg1hvs82xbdm5g5hirixvbzjpnjmkm8c4h4k38";
    })
    (fetchpatch {
      name = "cve-2019-12594.patch";
      url = "https://salsa.debian.org/debian/dosbox/raw/30989a35ee478f8f4bc8e167fccbf92fc77e1519/debian/patches/cve-2019-12594.patch?inline=false";
      excludes = ["configure.in"];
      sha256 = "1zrv2vnb86gdq9z4irqflzf7lz3r6rc6m46k1hdb8ldl1c88w8jj";
    })
  ];

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
