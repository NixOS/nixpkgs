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
# It's unknown which version of openssl that postman expects but it seems that
# OpenSSL 3+ seems to work fine (cf.
# https://github.com/NixOS/nixpkgs/issues/254325). If postman breaks apparently
# around OpenSSL stuff then try changing this dependency version.
, openssl
, xorg
, pname
, version
, meta
, copyDesktopItems
, makeWrapper
}:

let
  dist = {
    aarch64-linux = {
      arch = "arm64";
      sha256 = "sha256-shiUW7o6H0aaGCgHm3oVqjLZNsB4KIn7EIxWRVCAWi0=";
    };

    x86_64-linux = {
      arch = "64";
      sha256 = "sha256-R6mejxuxSZv37nyjnt/oGvgqCw1pULCHCWnlw+pq8iY=";
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

    source "${makeWrapper}/nix-support/setup-hook"
    wrapProgram $out/bin/${pname} \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--enable-features=UseOzonePlatform --ozone-platform=wayland}}"

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
    wrapProgram $out/bin/postman --set PATH ${lib.makeBinPath [ openssl ]}
  '';
}
