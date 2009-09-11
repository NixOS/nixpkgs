{ stdenv, fetchurl, lib, perl, gettext, libpng, giflib, libjpeg, alsaLib, readline, mesa
, pkgconfig, gtk, SDL, autoconf, automake, makeDesktopItem
}:

stdenv.mkDerivation rec {
  name = "vice-2.1";
  src = fetchurl {
    url = http://www.zimmers.net/anonftp/pub/cbm/crossplatform/emulators/VICE/vice-2.1.tar.gz;
    sha256 = "dc42df924bd4b4ab4af43e372d873a79ea035059f31f2f5c297c234b1c532c66";
  };
  buildInputs = [ perl gettext libpng giflib libjpeg alsaLib readline mesa
                  pkgconfig gtk SDL autoconf automake ];
  configureFlags = "--with-sdl --enable-fullscreen --enable-gnomeui";
  
  desktopItem = makeDesktopItem {
    name = "vice";
    exec = "x64";
    comment = "Commodore 64 emulator";
    desktopName = "VICE";
    genericName = "Commodore 64 emulator";
    categories = "Application;Emulator;";
  };

  patchPhase = ''
    # Disable font-cache update
    
    sed -i -e "s|install: install-data-am|install-no: install-data-am|" data/fonts/Makefile.am
    autoreconf -f -i
  '';
  
  postInstall = ''
    ensureDir $out/share/applications
    cp ${desktopItem}/share/applications/* $out/share/applications
  '';
  
  meta = {
    description = "Commodore 64, 128 and other emulators";
    homepage = http://www.viceteam.org;
    license = "GPL";
    maintainers = [ lib.maintainers.sander ];
  };
}
