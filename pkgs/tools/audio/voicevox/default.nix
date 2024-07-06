{ lib
, nodejs_18
, p7zip
, nodePackages
, fetchFromGitHub
, makeWrapper
, makeDesktopItem
, copyDesktopItems
, buildNpmPackage
, electron_27-bin
, electron
}:

buildNpmPackage rec {
  pname = "voicevox-linux-cpu";
  version = "0.15.2";

  src = fetchFromGitHub {
    owner = "VOICEVOX";
    repo = "voicevox";
    rev = "${version}";
    hash = "sha256-1xOOS3lsnZ1WWzQ5vLrkwOSwWwQjYhecWJV4mBMyVqU=";
  };

  #patches = [ ./remove-npm-restriction.patch ];

  npmDepsHash = "sha256-Ay7Q62HFXb7O2P0P1LNpxfM7j+dwWDyFUiqXrEo45j8=";
  npmBuildScript = "electron:build_dir";

  npmFlags = [ "--legacy-peer-deps" ];

  nodejs = nodejs_18;

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
    p7zip
    electron_27-bin
  ];

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  postPatch = ''
    substituteInPlace package.json \
      --replace-fail "<9" ""  
    substituteInPlace package.json \
      --replace-fail "&& node build/download7z.js" ""
    ln -s ${p7zip}/bin/7z build/vendored/7z/7zzs
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/lib/voicevox"
    mkdir -p "$out/share/icons/hicolor/1024x1024/apps"
    install -Dm644 ./deps/voicevox/public/icon.png $out/share/icons/hicolor/256x256/apps/voicevox.png

    makeWrapper "${electron}/bin/electron" "$out/bin/voicevox" \
      --add-flags "$out/share/lib/voicevox/resources/app.asar" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
      --inherit-argv0

    runHook postInstall
  '';

  distPhase = "true";

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      exec = pname;
      icon = "voicevox";
      desktopName = "VOICEVOX";
      genericName = "Voice Synthesizer";
      comment = meta.description;
      categories = ["Audio"];
      startupWMClass = pname;
    })
  ];


  meta = with lib; {
    description = "無料で使える中品質なテキスト読み上げソフトウェア、VOICEVOXのエディター";
    homepage = "https://voicevox.hiroshiba.jp/";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ maxhero ];
    mainProgram = "voicevox";
    inherit (electron.meta) platforms;
  };
}
