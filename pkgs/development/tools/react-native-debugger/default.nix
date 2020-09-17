{ stdenv, fetchurl, unzip, cairo, xorg, gdk-pixbuf, fontconfig, pango, gnome3, atk, at-spi2-atk, at-spi2-core
, gtk3, glib, freetype, dbus, nss, nspr, alsaLib, cups, expat, udev, makeDesktopItem
}:

let
  rpath = stdenv.lib.makeLibraryPath [
    cairo
    stdenv.cc.cc
    gdk-pixbuf
    fontconfig
    pango
    atk
    gtk3
    glib
    freetype
    dbus
    nss
    nspr
    alsaLib
    cups
    expat
    udev
    at-spi2-atk
    at-spi2-core

    xorg.libX11
    xorg.libXcursor
    xorg.libXtst
    xorg.libxcb
    xorg.libXext
    xorg.libXi
    xorg.libXdamage
    xorg.libXrandr
    xorg.libXcomposite
    xorg.libXfixes
    xorg.libXrender
    xorg.libXScrnSaver
  ];
in stdenv.mkDerivation rec {
  pname = "react-native-debugger";
  version = "0.11.4";
  src = fetchurl {
    url = "https://github.com/jhen0409/react-native-debugger/releases/download/v${version}/rn-debugger-linux-x64.zip";
    sha256 = "1dnlxdqcn90r509ff5003fibkrprdr0ydpnwg5p0xzs6rz3k8698";
  };

  buildInputs = [ unzip ];
  buildCommand = ''
    shopt -s extglob
    mkdir -p $out
    unzip $src -d $out

    mkdir $out/{lib,bin,share}
    mv $out/{libEGL,libGLESv2,libvk_swiftshader,libffmpeg}.so $out/lib
    mv $out/!(lib|share|bin) $out/share

    patchelf \
      --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      --set-rpath ${rpath}:$out/lib \
      $out/share/react-native-debugger

    ln -s $out/share/react-native-debugger $out/bin/react-native-debugger

    install -Dm644 "${desktopItem}/share/applications/"* \
      -t $out/share/applications/
  '';

  desktopItem = makeDesktopItem {
    name = "rndebugger";
    exec = "react-native-debugger";
    desktopName = "React Native Debugger";
    genericName = "React Native Debugger";
    categories = "Development;Debugger;";
  };

  meta = with stdenv.lib; {
    homepage = "https://github.com/jhen0409/react-native-debugger";
    license = licenses.mit;
    description = "The standalone app based on official debugger of React Native, and includes React Inspector / Redux DevTools";
    maintainers = with maintainers; [ ];
  };
}
