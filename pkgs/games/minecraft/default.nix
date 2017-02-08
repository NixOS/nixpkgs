{ stdenv, fetchurl, makeDesktopItem, makeWrapper
, libX11, libXext, libXcursor, libXrandr, libXcomposite, libXdamage, libXfixes
, libXi, libXrender, libXScrnSaver, libXtst, gtk2, gdk_pixbuf
, gcc6, icu, freetype, GConf, libpulseaudio, alsaLib, cups, dbus, atk
, glib, fontconfig, nss, pango, cairo, expat, nspr, pciutils
, jre
, mesa, openal #still needed? not in deps yet
}:
with stdenv.lib;

let
  desktopItem = makeDesktopItem {
    name = "minecraft";
    exec = "minecraft";
    icon = "minecraft";
    comment = "A sandbox-building game";
    desktopName = "Minecraft";
    genericName = "minecraft";
    categories = "Game;";
  };
  deps = [ libX11 libXext libXcursor libXrandr libXcomposite libXdamage libXfixes
    libXi libXrender libXScrnSaver libXtst gtk2 gdk_pixbuf
    gcc6.cc icu freetype GConf libpulseaudio alsaLib cups dbus atk
    glib fontconfig nss pango cairo expat nspr pciutils ];

in stdenv.mkDerivation {
  name = "minecraft-2.0.759"; #launcher version

  src = fetchurl {
    url = "https://launcher.mojang.com/mc-staging/download/Minecraft_staging.tar.gz";
    sha256 = "0d4g122as9c297jfh4fn69nvqva6kfrf16xwsg199ligv7cplzrg";
  };

  nativeBuildInputs = [ makeWrapper ];

  phases = "unpackPhase installPhase";

  unpackPhase = ''
    set -x
    tar xf $src
  '';

  installPhase = ''
    set -x
    mkdir -pv $out/share/minecraft
    mv -v minecraft-launcher*/* $out/share/minecraft

    patchelf \
      --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath $out/share/minecraft $out/share/minecraft/launcher

    patchelf \
      --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      $out/share/minecraft/chrome-sandbox

    wrapProgram $out/share/minecraft/launcher \
      --prefix LD_LIBRARY_PATH : "${makeLibraryPath deps}" \
      --prefix PATH : "${jre}/bin"

    mkdir -pv $out/bin
    ln -s $out/share/minecraft/minecraft-launcher.sh $out/bin/minecraft

    mkdir -p $out/share/applications
    ln -s ${desktopItem}/share/applications/* $out/share/applications/
  '';

  meta = {
      description = "A sandbox-building game";
      homepage = http://www.minecraft.net;
      maintainers = with stdenv.lib.maintainers; [ cpages ryantm ];
      license = stdenv.lib.licenses.unfreeRedistributable;
  };
}
