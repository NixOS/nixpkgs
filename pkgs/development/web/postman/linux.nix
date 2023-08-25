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

let
  dist = {
    aarch64-linux = {
      arch = "arm64";
      sha256 = "sha256-cBueTCZHZZGU3Z/UKLBIw4XCvCz9Hm4MxdIMY9+2ulk=";
    };

    x86_64-linux = {
      arch = "64";
      sha256 = "sha256-svk60K4pZh0qRdx9+5OUTu0xgGXMhqvQTGTcmqBOMq8=";
    };
  }.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

in
stdenv.mkDerivation rec {
  inherit pname version meta;

  src = fetchurl {
    url = "https://dl.pstmn.io/download/version/${version}/linux${dist.arch}";
    inherit (dist) sha256;
    name = "${pname}-${version}.tar.gz";
  };

  dontConfigure = true;

  desktopItems = [
      (makeDesktopItem {
      name = "postman";
      exec = "postman";
      icon = "postman";
      comment = "API Development Environment";
      desktopName = "Postman";
      genericName = "Postman";
      categories = [ "Development" ];
    })
  ];

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

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/postman
    cp -R app/* $out/share/postman
    rm $out/share/postman/Postman

    mkdir -p $out/bin
    ln -s $out/share/postman/postman $out/bin/postman

    mkdir -p $out/share/icons/hicolor/128x128/apps
    ln -s $out/share/postman/resources/app/assets/icon.png $out/share/icons/postman.png
    ln -s $out/share/postman/resources/app/assets/icon.png $out/share/icons/hicolor/128x128/apps/postman.png
    runHook postInstall
  '';

  postFixup = ''
    pushd $out/share/postman
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" postman
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" chrome_crashpad_handler
    for file in $(find . -type f \( -name \*.node -o -name postman -o -name \*.so\* \) ); do
      ORIGIN=$(patchelf --print-rpath $file); \
      patchelf --set-rpath "${lib.makeLibraryPath buildInputs}:$ORIGIN" $file
    done
    popd
  '';
}
