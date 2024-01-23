{ lib
, fetchzip
, libXxf86vm
, libGL
, makeWrapper
, openal
, openjdk
, stdenv
, xorg
, copyDesktopItems
, makeDesktopItem
, writeScript
}:

stdenv.mkDerivation rec {
  pname = "starsector";
  version = "0.96a-RC10";

  src = fetchzip {
    url = "https://f005.backblazeb2.com/file/fractalsoftworks/release/starsector_linux-${version}.zip";
    sha256 = "sha256-RBSnms+QlKgTOhm3t2hDfv7OcMrQCk1rfkz9GaM74WM=";
  };

  nativeBuildInputs = [ copyDesktopItems makeWrapper ];
  buildInputs = [ xorg.libXxf86vm openal libGL ];

  dontBuild = true;

  desktopItems = [
    (makeDesktopItem {
      name = "starsector";
      exec = "starsector";
      icon = "starsector";
      comment = meta.description;
      genericName = "starsector";
      desktopName = "Starsector";
      categories = [ "Game" ];
    })
  ];

  # need to cd into $out in order for classpath to pick up correct jar files
  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/starsector
    rm -r jre_linux # remove bundled jre7
    rm starfarer.api.zip
    cp -r ./* $out/share/starsector

    mkdir -p $out/share/icons/hicolor/64x64/apps
    ln -s $out/graphics/ui/s_icon64.png $out/share/icons/hicolor/64x64/apps/starsector.png

    wrapProgram $out/share/starsector/starsector.sh \
      --prefix PATH : ${lib.makeBinPath [ openjdk xorg.xrandr ]} \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath buildInputs} \
      --run 'mkdir -p ''${XDG_DATA_HOME:-~/.local/share}/starsector' \
      --chdir "$out/share/starsector"
    ln -s $out/share/starsector/starsector.sh $out/bin/starsector

    runHook postInstall
  '';

  # it tries to run everything with relative paths, which makes it CWD dependent
  # also point mod, screenshot, and save directory to $XDG_DATA_HOME
  # additionally, add some GC options to improve performance of the game
  postPatch = ''
    substituteInPlace starsector.sh \
      --replace "./jre_linux/bin/java" "${openjdk}/bin/java" \
      --replace "./native/linux" "$out/share/starsector/native/linux" \
      --replace "=." "=\''${XDG_DATA_HOME:-\$HOME/.local/share}/starsector" \
      --replace "-XX:+CompilerThreadHintNoPreempt" "-XX:+UnlockDiagnosticVMOptions -XX:-BytecodeVerificationRemote -XX:+UseConcMarkSweepGC -XX:+UseParNewGC -XX:+CMSConcurrentMTEnabled -XX:+DisableExplicitGC"
  '';

  meta = with lib; {
    description = "Open-world single-player space-combat, roleplaying, exploration, and economic game";
    homepage = "https://fractalsoftworks.com";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ bbigras rafaelrc ];
  };

  passthru.updateScript = writeScript "starsector-update-script" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl gnugrep common-updater-scripts
    set -eou pipefail;
    version=$(curl -s https://fractalsoftworks.com/preorder/ | grep -oP "https://f005.backblazeb2.com/file/fractalsoftworks/release/starsector_linux-\K.*?(?=\.zip)" | head -1)
    update-source-version ${pname} "$version" --file=./pkgs/games/starsector/default.nix
  '';
}
