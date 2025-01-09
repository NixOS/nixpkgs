{ stdenv, lib, fetchurl, patchelf, makeWrapper, writeShellApplication, makeDesktopItem, gtk3, glib, xorg, remarkable2-toolchain, bash, autoPatchelfHook, copyDesktopItems }:

let
  acesx86_64 = writeShellApplication {
  name = "acesx86_64";
  runtimeInputs = [ bash ];

  text = ''
    #!/bin/bash

    STORE_PATH=$(dirname "$(dirname "$(readlink -f "$(which launcher)")")")

    echo "$STORE_PATH"
    echo "DEBUG::: STORE_PATH = $STORE_PATH"
    echo "Check for home directory, create if not present."
    export ACES64_DIR=$HOME/.aces64/War-Thunder-086d99e/

    if [ ! -d "$HOME/.aces64/War-Thunder-086d99e" ]; then

      echo "DEBUG::: Directory not found. Fuck."

      mkdir -p "$HOME/.aces64/War-Thunder-086d99e"
      cd "$HOME/.aces64/War-Thunder-086d99e"

      echo "DEBUG::: Directory created and CD'ed."
      echo "DEBUG::: Setting Enviroment variables for runtime again."
      export ACES64_DIR=$HOME/.aces64/War-Thunder-086d99e/
      else
        echo "DEBUG::: Directory exits, fucking good.."
    fi
    echo "Installing launcher, bpreport, and selfupdater scripts to the user directory"

    install -m755 -D \
    "$STORE_PATH"/War-Thunder-086d99e/launcher "$ACES64_DIR/launcher"

    install -m755 -D \
    "$STORE_PATH"/War-Thunder-086d99e/gaijin_selfupdater "$ACES64_DIR/gaijin_selfupdater"

    install -m755 -D \
    "$STORE_PATH"/War-Thunder-086d99e/bpreport "$ACES64_DIR/bpreport"

    cp -f "$STORE_PATH"/War-Thunder-086d99e/ca-bundle.crt "$ACES64_DIR/ca-bundle.crt"
    cp -f "$STORE_PATH"/War-Thunder-086d99e/launcherr.dat "$ACES64_DIR/launcherr.dat"
    cp -f "$STORE_PATH"/War-Thunder-086d99e/libsciter-gtk.so "$ACES64_DIR/libsciter-gtk.so"
    cp -f "$STORE_PATH"/War-Thunder-086d99e/libsteam_api.so "$ACES64_DIR/libsteam_api.so"
    cp -f "$STORE_PATH"/War-Thunder-086d99e/package.blk "$ACES64_DIR/package.blk"
    cp -f "$STORE_PATH"/War-Thunder-086d99e/yupartner.blk "$ACES64_DIR/yupartner.blk"





    cd "$ACES64_DIR" || { echo "cd command rejected, breaking"; exit 1; }
    echo "DEBUG::: Changing root directory to $ACES64_DIR"
    echo "DEBUG::: Where the fuck am i. $PWD"

    exec "$ACES64_DIR/launcher"
    '';}; in
stdenv.mkDerivation rec {
  name = "WarThunder";
  pname = "War-Thunder";
  version = "086d99e";

  src = fetchurl {
    url = "https://github.com/Mephist0phel3s/War-Thunder/archive/refs/tags/086d99e.tar.gz";
    hash = "sha256-vqpx85ZT1AzKk7dkZvMDMJf9GWalDM/F2JhaiMybMoY=";
  };


  sourceRoot = "./${pname}-${version}";
  unpackPhase = false;
  dontConfigure = true;
  dontBuild = true;
  nativeBuildInputs = [ copyDesktopItems ];
  buildInputs = [ autoPatchelfHook stdenv.cc.cc stdenv.cc.cc.lib remarkable2-toolchain glib gtk3 xorg.libX11 xorg.libXrandr ];

#  patchPhase = let


libPath = lib.makeLibraryPath [ autoPatchelfHook stdenv.cc.cc stdenv.cc.cc.lib remarkable2-toolchain glib gtk3 xorg.libX11 xorg.libXrandr];


  installPhase = ''
  runHook preInstall
    mkdir -p $out/${pname}-${version}
    mkdir -p $out/share/pixmaps
    mkdir -p $out/bin

    if [ -f "${acesx86_64}/bin/acesx86_64" ]; then
      install -m755 -D ${acesx86_64}/bin/acesx86_64 $out/bin/acesx86_64
    else
      echo "FATAL ERROR DEBUG::: acesx86_64 script not found at ${acesx86_64}, breaking."
      exit 1
    fi

    install -m755 -D launcher $out/${pname}-${version}/launcher
    install -m755 -D gaijin_selfupdater $out/${pname}-${version}/gaijin_selfupdater
    install -m755 -D bpreport $out/${pname}-${version}/bpreport

    cp ca-bundle.crt $out/${pname}-${version}/ca-bundle.crt
    cp launcherr.dat $out/${pname}-${version}/launcherr.dat
    cp libsciter-gtk.so $out/${pname}-${version}/libsciter-gtk.so
    cp libsteam_api.so $out/${pname}-${version}/libsteam_api.so
    cp package.blk $out/${pname}-${version}/package.blk
    cp yupartner.blk $out/${pname}-${version}/yupartner.blk

    echo "STORE_PATH=\"$out/${pname}-${version}\"" > $out/${pname}-${version}/store_path.txt

    echo "DEBUG::: Running patchelf to link binaries"
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath ${libPath} launcher
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath ${libPath} bpreport
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath ${libPath} gaijin_selfupdater
    echo "DEBUG::: Done, proceeding."

    install -m755 -D launcher.ico $out/share/pixmaps/launcher.png
    echo "DEBUG::: Installing the fucking desktop file"
    mkdir -p "$out/share/applications"
    echo "INFO: Skpipping cp -rf desktopItem"
    echo "INFO: sym linking aces to WarThunder for purposes of desktop execution."
    ln -s ${acesx86_64}/bin/acesx86_64 $out/bin/WarThunder

    echo "INFO: Installing bins to out/bin"
    install -m755 -D launcher $out/bin
    install -m755 -D gaijin_selfupdater "$out/bin"
    install -m755 -D bpreport "$out/bin"
    echo "INFO: Done"

  runHook postInstall
  '';

  postInstallPhase = let

  desktopItem = makeDesktopItem {
    name = "War-Thunder";
    exec = "acesx86_64";
    icon = "launcher";
    desktopName = "War Thunder";
    genericName = "War Thunder";
    categories = [ "Game" ];
    }; in ''

    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/${name}.desktop $out/share/${name}.desktop

'';


  meta = with lib; {
    homepage = "https://warthunder.com/";
    description = "Military Vehicle PVP simulator, tanks, planes, warships";
    platforms = platforms.linux;
  };
}
