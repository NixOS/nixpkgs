{
  lib,
  stdenv,
  fetchurl,
  unzip,
  cairo,
  xorg,
  gdk-pixbuf,
  fontconfig,
  pango,
  gnome,
  atk,
  at-spi2-atk,
  at-spi2-core,
  gtk3,
  glib,
  freetype,
  dbus,
  nss,
  nspr,
  alsa-lib,
  cups,
  expat,
  udev,
  makeDesktopItem,
  libdrm,
  libxkbcommon,
  mesa,
  makeWrapper,
}:

let
  rpath = lib.makeLibraryPath [
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
    alsa-lib
    cups
    expat
    udev
    at-spi2-atk
    at-spi2-core
    libdrm
    libxkbcommon
    mesa

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
in
stdenv.mkDerivation rec {
  pname = "react-native-debugger";
  version = "0.14.0";
  src = fetchurl {
    url = "https://github.com/jhen0409/react-native-debugger/releases/download/v${version}/rn-debugger-linux-x64.zip";
    sha256 = "sha256-RioBe0MAR47M84aavFaTJikGsJtcZDak8Tkg3WtX2l0=";
  };

  nativeBuildInputs = [
    makeWrapper
    unzip
  ];
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

    wrapProgram $out/share/react-native-debugger \
      --add-flags --no-sandbox

    ln -s $out/share/react-native-debugger $out/bin/react-native-debugger

    install -Dm644 "${desktopItem}/share/applications/"* \
      -t $out/share/applications/
  '';

  desktopItem = makeDesktopItem {
    name = "rndebugger";
    exec = "react-native-debugger";
    desktopName = "React Native Debugger";
    genericName = "React Native Debugger";
    categories = [
      "Development"
      "Debugger"
    ];
  };

  meta = with lib; {
    homepage = "https://github.com/jhen0409/react-native-debugger";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.mit;
    description = "The standalone app based on official debugger of React Native, and includes React Inspector / Redux DevTools";
    mainProgram = "react-native-debugger";
    maintainers = with maintainers; [ ];
  };
}
