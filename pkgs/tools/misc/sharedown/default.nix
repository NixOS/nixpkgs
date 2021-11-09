{ stdenvNoCC
, lib
, fetchFromGitHub
, ffmpeg
, yt-dlp
, electron
, makeWrapper
, makeDesktopItem
, copyDesktopItems
, yarnSetupHook
, yarn2nix-moretea
, chromium
}:

stdenvNoCC.mkDerivation rec {
  pname = "Sharedown";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "kylon";
    repo = pname;
    rev = version;
    sha256 = "sha256-Z6OsZvVzk//qEkl4ciNz4cQRqC2GFg0qYgmliAyz6fo=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
    yarnSetupHook
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "Sharedown";
      exec = "Sharedown";
      icon = "Sharedown";
      comment = "An Application to save your Sharepoint videos for offline usage.";
      desktopName = "Sharedown";
      categories = "Network;Archiving";
    })
  ];

  dontBuild = true;

  prePatch = ''
    cp ${./yarn.lock} ./yarn.lock
    chmod u+w yarn.lock
  '';
  offlineCache = yarn2nix-moretea.importOfflineCache ./yarndeps.nix;
  yarnFlags = yarnSetupHook.defaultYarnFlags ++ [ "--production" ];

  installPhase =
    let
      binPath = lib.makeBinPath ([
        ffmpeg
        yt-dlp
      ]);

    in
    ''
      runHook preInstall

      mkdir -p "$out/bin" "$out/share/Sharedown" "$out/share/applications" "$out/share/icons/hicolor/512x512/apps"

      # Electron app
      cp -r *.js *.json sharedownlogo.png sharedown node_modules "$out/share/Sharedown"

      # Desktop Launcher
      cp build/icon.png "$out/share/icons/hicolor/512x512/apps/Sharedown.png"

      # Install electron wrapper script
      makeWrapper "${electron}/bin/electron" "$out/bin/Sharedown" \
        --add-flags "$out/share/Sharedown" \
        --prefix PATH : "${binPath}" \
        --set PUPPETEER_EXECUTABLE_PATH "${chromium}/bin/chromium"

      runHook postInstall
    '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Application to save your Sharepoint videos for offline usage";
    homepage = "https://github.com/kylon/Sharedown";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      jtojnar
    ];
    platforms = platforms.unix;
  };
}
