{ stdenv, fetchurl, perl, gettext, libpng, giflib, libjpeg, alsaLib, readline, mesa, libX11
, pkgconfig, gtk, SDL, autoconf, automake, makeDesktopItem
}:

stdenv.mkDerivation rec {
  name = "vice-2.2";
  src = fetchurl {
    url = http://www.zimmers.net/anonftp/pub/cbm/crossplatform/emulators/VICE/vice-2.2.tar.gz;
    sha256 = "0l8mp9ybx494fdqgr1ps4x3c3qzms4yyg4hzcn3ihzy92zw1nn2x";
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
  
  NIX_LDFLAGS = "-lX11 -L${libX11}/lib";
  
  postInstall = ''
    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/* $out/share/applications
  '';
  
  meta = {
    description = "Commodore 64, 128 and other emulators";
    homepage = http://www.viceteam.org;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
