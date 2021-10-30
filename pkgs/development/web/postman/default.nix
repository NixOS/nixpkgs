{ lib, stdenv, fetchurl, makeDesktopItem, wrapGAppsHook
, atk, at-spi2-atk, at-spi2-core, alsa-lib, cairo, cups, dbus, expat, gdk-pixbuf, glib, gtk3
, freetype, fontconfig, nss, nspr, pango, udev, libuuid, libX11, libxcb, libXi
, libXcursor, libXdamage, libXrandr, libXcomposite, libXext, libXfixes
, libXrender, libXtst, libXScrnSaver, libxkbcommon, libdrm, mesa
}:

stdenv.mkDerivation rec {
  pname = "postman";
  version = "9.1.1";

  src = fetchurl {
    url = "https://dl.pstmn.io/download/version/${version}/linux64";
    sha256 = "QqlA/8fEOwucs+nU6ahDh3GB64PdhY8JFWPiyEBxGsE=";
    name = "${pname}.tar.gz";
  };

  dontBuild = true; # nothing to build
  dontConfigure = true;

  desktopItem = makeDesktopItem {
    name = "postman";
    exec = "postman";
    icon = "postman";
    comment = "API Development Environment";
    desktopName = "Postman";
    genericName = "Postman";
    categories = "Development;";
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
  ];

  nativeBuildInputs = [ wrapGAppsHook ];


  installPhase = ''
    mkdir -p $out/share/postman
    cp -R app/* $out/share/postman
    rm $out/share/postman/Postman

    mkdir -p $out/bin
    ln -s $out/share/postman/postman $out/bin/postman

    mkdir -p $out/share/applications
    ln -s ${desktopItem}/share/applications/* $out/share/applications/

    iconRootDir=$out/share/icons
    iconSizeDir=$out/share/icons/hicolor/128x128/apps
    mkdir -p $iconSizeDir
    ln -s $out/share/postman/resources/app/assets/icon.png $iconRootDir/postman.png
    ln -s $out/share/postman/resources/app/assets/icon.png $iconSizeDir/postman.png
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

  meta = with lib; {
    homepage = "https://www.getpostman.com";
    description = "API Development Environment";
    license = licenses.postman;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ johnrichardrinehart evanjs ];
  };
}
