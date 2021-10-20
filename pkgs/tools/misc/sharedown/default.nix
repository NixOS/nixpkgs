{ stdenvNoCC
, lib
, fetchFromGitHub
, ffmpeg
, yt-dlp
, electron
, makeWrapper
, makeDesktopItem
, copyDesktopItems
, yarn2nix-moretea
, chromium
}:

let
  binPath = lib.makeBinPath ([
    ffmpeg
    yt-dlp
  ]);

  pname = "Sharedown";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "kylon";
    repo = pname;
    rev = version;
    sha256 = "sha256-Z6OsZvVzk//qEkl4ciNz4cQRqC2GFg0qYgmliAyz6fo=";
  };

  modules = yarn2nix-moretea.mkYarnModules {
    name = "${pname}-modules-${version}";
    inherit pname version;

    yarnFlags = yarn2nix-moretea.defaultYarnFlags ++ [
      "--production"
    ];

    packageJSON = "${src}/package.json";
    yarnLock = ./yarn.lock;
    yarnNix = ./yarndeps.nix;
  };
in
stdenvNoCC.mkDerivation rec {
  inherit pname version src;

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
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

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin" "$out/share/Sharedown" "$out/share/applications" "$out/share/icons/hicolor/512x512/apps"

    # Electron app
    cp -r *.js *.json sharedownlogo.png sharedown "${modules}/node_modules" "$out/share/Sharedown"

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
