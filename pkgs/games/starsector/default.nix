{ lib
, alsa-lib
, fetchzip
, libXxf86vm
, makeWrapper
, openjdk
, stdenv
, xorg
, copyDesktopItems
, makeDesktopItem
}:

stdenv.mkDerivation rec {
  pname = "starsector";
  version = "0.95.1a-RC5";

  src = fetchzip {
    url = "https://s3.amazonaws.com/fractalsoftworks/starsector/starsector_linux-${version}.zip";
    sha256 = "sha256-V8/WQPvPIrF3Tg7JVO+GfeYqWhkWWrnHSVcFXGQqDAA=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
  ];
  buildInputs = with xorg; [
    alsa-lib
    libXxf86vm
  ];

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

    mkdir -p $out/bin
    rm -r jre_linux # remove jre7
    rm starfarer.api.zip
    cp -r ./* $out

    mkdir -p $out/share/icons/hicolor/64x64/apps
    ln -s $out/graphics/ui/s_icon64.png $out/share/icons/hicolor/64x64/apps/starsector.png

    wrapProgram $out/starsector.sh \
      --prefix PATH : ${lib.makeBinPath [ openjdk ]} \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath buildInputs} \
      --run 'mkdir -p ''${XDG_DATA_HOME:-~/.local/share}/starsector; cd '"$out"
    ln -s $out/starsector.sh $out/bin/starsector

    runHook postInstall
  '';

  # it tries to run everything with relative paths, which makes it CWD dependent
  # also point mod, screenshot, and save directory to $XDG_DATA_HOME
  postPatch = ''
    substituteInPlace starsector.sh \
      --replace "./jre_linux/bin/java" "${openjdk}/bin/java" \
      --replace "./native/linux" "$out/native/linux"
  '';

  meta = with lib; {
    description = "Open-world single-player space-combat, roleplaying, exploration, and economic game";
    homepage = "https://fractalsoftworks.com";
    license = licenses.unfree;
    maintainers = with maintainers; [ bbigras ];
  };
}
