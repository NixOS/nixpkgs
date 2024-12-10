{
  stdenv,
  lib,
  runCommand,
  buildEnv,
  makeWrapper,
  makeDesktopItem,
  gamePacks,
  libstdcxx5,
  SDL,
  openal,
}:

let
  game = buildEnv {
    name = "ut2004-game";
    paths = gamePacks;
    ignoreCollisions = true;
    pathsToLink = [
      "/"
      "/System"
    ];
    postBuild = ''
      ln -s ${lib.getLib SDL}/lib/libSDL-1.2.so.0 $out/System
      ln -s ${lib.getLib openal}/lib/libopenal.so $out/System/openal.so
      for i in $out/System/*-bin; do
        path="$(readlink -f "$i")"
        rm "$i"
        cp "$path" "$i"
        chmod +w "$i"
        patchelf \
          --set-interpreter $(cat ${stdenv.cc}/nix-support/dynamic-linker) \
          --set-rpath "$out/System:${lib.makeLibraryPath [ libstdcxx5 ]}" \
          "$i"
      done
    '';
  };

  desktop = makeDesktopItem {
    name = "ut2004";
    desktopName = "Unreal Tournament 2004";
    comment = "A first-person shooter video game developed by Epic Games and Digital Extreme";
    genericName = "First-person shooter";
    categories = [ "Game" ];
    exec = "ut2004";
  };

in
runCommand "ut2004"
  {
    nativeBuildInputs = [ makeWrapper ];
  }
  ''
    mkdir -p $out/bin
    for i in ${game}/System/*-bin; do
      name="$(basename "$i")"
      makeWrapper $i $out/bin/''${name%-bin} \
        --chdir "${game}/System"
    done

    mkdir -p $out/share/applications
    ln -s ${desktop}/share/applications/* $out/share/applications
  ''
