{ lib, stdenv, requireFile, unzip, makeDesktopItem, SDL2, SDL2_mixer, libogg, libvorbis }:

let
  arch = if stdenv.system == "x86_64-linux"
    then "x86_64"
    else "x86";

  desktopItem = makeDesktopItem {
    desktopName = "World of Goo";
    genericName = "World of Goo";
    categories = [ "Game" ];
    exec = "WorldOfGoo.bin.${arch}";
    icon = "2dboy-worldofgoo";
    name = "worldofgoo";
  };

in

stdenv.mkDerivation rec {
  pname = "WorldOfGoo";
  version = "1.53";

  helpMsg = ''
    We cannot download the full version automatically, as you require a license.
    Once you have bought a license, you need to add your downloaded version to the nix store.
    You can do this by using "nix-prefetch-url file://\$PWD/${pname}.Linux${version}.sh"
    in the directory where you saved it.
  '';

  src = requireFile {
    message = helpMsg;
    name = "WorldOfGoo.Linux.1.53.sh";
    sha256 = "175e4b0499a765f1564942da4bd65029f8aae1de8231749c56bec672187d53ee";
  };

  nativeBuildInputs = [ unzip ];
  sourceRoot = pname;
  phases = [ "unpackPhase installPhase" ];

  libPath = lib.makeLibraryPath [ stdenv.cc.cc.lib stdenv.cc.libc SDL2 SDL2_mixer
    libogg libvorbis ];

  unpackPhase = ''
    # The game is distributed as a shell script, with a tar of mojosetup, and a
    # zip archive attached to the end. Therefore a simple unzip does the job.
    # However, to avoid unzip errors, we need to strip those out first.
    tail -c +421887 ${src} > ${src}.zip
    unzip -q ${src}.zip -d ${pname}
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share/applications $out/share/icons/hicolor/256x256/apps

    install -t $out/bin -m755 data/${arch}/WorldOfGoo.bin.${arch}
    cp -R data/noarch/* $out/bin
    cp data/noarch/game/gooicon.png $out/share/icons/hicolor/256x256/apps/2dboy-worldofgoo.png
    cp ${desktopItem}/share/applications/worldofgoo.desktop \
      $out/share/applications/worldofgoo.desktop

    patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" --set-rpath $libPath $out/bin/WorldOfGoo.bin.${arch}
  '';

  meta = with lib; {
    description = "A physics based puzzle game";
    longDescription = ''
      World of Goo is a physics based puzzle / construction game. The millions of Goo
      Balls who live in the beautiful World of Goo don't know that they are in a
      game, or that they are extremely delicious.
    '';
    homepage = "https://worldofgoo.com";
    license = licenses.unfree;
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = with maintainers; [ jcumming maxeaubrey ];
  };
}
