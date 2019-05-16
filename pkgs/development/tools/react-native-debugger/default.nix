{ stdenv, fetchurl, unzip, cairo, xorg, gdk_pixbuf, fontconfig, pango, gnome2, atk, gtk2, glib
, freetype, dbus, nss, nspr, alsaLib, cups, expat, udev, makeDesktopItem
}:

let
  rpath = stdenv.lib.makeLibraryPath [
    cairo
    stdenv.cc.cc
    gdk_pixbuf
    fontconfig
    pango
    atk
    gtk2
    glib
    freetype
    dbus
    nss
    nspr
    alsaLib
    cups
    expat
    udev

    gnome2.GConf

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
  name = "react-native-debugger-${version}";
  version = "0.9.8";

  src = fetchurl {
    url = "https://github.com/jhen0409/react-native-debugger/releases/download/v${version}/rn-debugger-linux-x64.zip";
    sha256 = "07mcliy5f3kcqr76izqirqzwb2rwbnl3k1al9dln1izim0lhx06r";
  };

  buildInputs = [ unzip ];
  buildCommand = ''
    shopt -s extglob
    mkdir -p $out
    unzip $src -d $out

    mkdir $out/{lib,bin,share}
    mv $out/lib{node,ffmpeg}.so $out/lib
    mv $out/!(lib|share|bin) $out/share

    patchelf \
      --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
      --set-rpath ${rpath}:$out/lib \
      $out/share/React\ Native\ Debugger

    ln -s $out/share/React\ Native\ Debugger $out/bin/React\ Native\ Debugger

    install -Dm644 "${desktopItem}/share/applications/"* \
      -t $out/share/applications/
  '';

  desktopItem = makeDesktopItem {
    name = "rndebugger";
    exec = "React\\ Native\\ Debugger";
    desktopName = "React Native Debugger";
    genericName = "React Native Debugger";
    categories = "Development;Tools;";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/jhen0409/react-native-debugger;
    license = licenses.mit;
    description = "The standalone app based on official debugger of React Native, and includes React Inspector / Redux DevTools";
    maintainers = with maintainers; [ ma27 ];
  };
}
