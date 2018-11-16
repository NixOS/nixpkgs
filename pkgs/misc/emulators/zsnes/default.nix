{stdenv, fetchFromGitHub, nasm, SDL, zlib, libpng, ncurses, libGLU_combined
, makeDesktopItem }:

let
  desktopItem = makeDesktopItem {
    name = "zsnes";
    exec = "zsnes";
    icon = "zsnes";
    comment = "A SNES emulator";
    desktopName = "zsnes";
    genericName = "zsnes";
    categories = "Game;";
  };

in stdenv.mkDerivation {
  name = "zsnes-1.51";

  src = fetchFromGitHub {
    owner = "emillon";
    repo = "zsnes";
    rev = "fc160b2538738995f600f8405d23a66b070dac02";
    sha256 = "1gy79d5wdaacph0cc1amw7mqm7i0716n6mvav16p1svi26iz193v";
  };

  buildInputs = [ nasm SDL zlib libpng ncurses libGLU_combined ];

  prePatch = ''
    for i in $(cat debian/patches/series); do
      echo "applying $i"
      patch -p1 < "debian/patches/$i"
    done
  '';

  preConfigure = ''
    cd src
    sed -i "/^STRIP/d" configure
    sed -i "/\$STRIP/d" configure
  '';

  configureFlags = [ "--enable-release" ];

  postInstall = ''
    function installIcon () {
        mkdir -p $out/share/icons/hicolor/$1/apps/
        cp icons/$1x32.png $out/share/icons/hicolor/$1/apps/zsnes.png
    }
    installIcon "16x16"
    installIcon "32x32"
    installIcon "48x48"
    installIcon "64x64"

    mkdir -p $out/share/applications
    ln -s ${desktopItem}/share/applications/* $out/share/applications/
  '';

  meta = {
    description = "A Super Nintendo Entertainment System Emulator";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers.sander ];
    homepage = http://www.zsnes.com;
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
