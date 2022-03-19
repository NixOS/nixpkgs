{ lib
, stdenv
, fetchurl
, makeDesktopItem
, wrapGAppsHook
, atk
, at-spi2-atk
, at-spi2-core
, alsa-lib
, cairo
, cups
, dbus
, expat
, gdk-pixbuf
, glib
, gtk3
, freetype
, fontconfig
, nss
, nspr
, pango
, udev
, libuuid
, libX11
, libxcb
, libXi
, libXcursor
, libXdamage
, libXrandr
, libXcomposite
, libXext
, libXfixes
, libXrender
, libXtst
, libXScrnSaver
, libxkbcommon
, libdrm
, mesa
, xorg
, pname
, version
, meta
, copyDesktopItems
}:

stdenv.mkDerivation rec {
  inherit pname version meta;

  src = fetchurl {
    url = "https://dl.pstmn.io/download/version/${version}/linux64";
    sha256 = "sha256-pA3gT4xoIWhajY03JzVgHK5KyTx1uH6gyasuLTdt6cM=";
    name = "${pname}.tar.gz";
  };

  dontConfigure = true;

  desktopItem = makeDesktopItem {
    name = "postman";
    exec = "postman";
    icon = "postman";
    comment = "API Development Environment";
    desktopName = "Postman";
    genericName = "Postman";
    categories = [ "Development" ];
  };

  buildInputs = [
    stdenv.cc.cc.lib
    atk
    at-spi2-atk
    at-spi2-core
    alsa-lib
    cairo
    cups
    dbus
    expat
    gdk-pixbuf
    glib
    gtk3
    freetype
    fontconfig
    mesa
    nss
    nspr
    pango
    udev
    libdrm
    libuuid
    libX11
    libxcb
    libXi
    libXcursor
    libXdamage
    libXrandr
    libXcomposite
    libXext
    libXfixes
    libXrender
    libXtst
    libXScrnSaver
    libxkbcommon
    xorg.libxshmfence
  ];

  nativeBuildInputs = [ wrapGAppsHook copyDesktopItems ];

  desktopItems = [ desktopItem ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/postman
    cp -R app/* $out/share/postman
    rm $out/share/postman/Postman

    mkdir -p $out/bin
    ln -s $out/share/postman/postman $out/bin/postman

    iconRootDir=$out/share/icons
    iconSizeDir=$out/share/icons/hicolor/128x128/apps
    mkdir -p $iconSizeDir
    ln -s $out/share/postman/resources/app/assets/icon.png $iconRootDir/postman.png
    ln -s $out/share/postman/resources/app/assets/icon.png $iconSizeDir/postman.png
    runHook postInstall
  '';

  postFixup = ''
    pushd $out/share/postman
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" postman
    for file in $(find . -type f \( -name \*.node -o -name postman -o -name \*.so\* \) ); do
      ORIGIN=$(patchelf --print-rpath $file); \
      patchelf --set-rpath "${lib.makeLibraryPath buildInputs}:$ORIGIN" $file
    done
    popd
  '';
}
