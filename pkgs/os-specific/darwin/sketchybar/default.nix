{ lib
, stdenv
, fetchFromGitHub
, AppKit
, Carbon
, CoreAudio
, CoreWLAN
, CoreVideo
, DisplayServices
, IOKit
, MediaRemote
, SkyLight
, testers
, nix-update-script
}:

let
  inherit (stdenv.hostPlatform) system;
  target = {
    "aarch64-darwin" = "arm64";
    "x86_64-darwin" = "x86";
  }.${system} or (throw "Unsupported system: ${system}");
in
stdenv.mkDerivation (finalAttrs: {
  pname = "sketchybar";
  version = "2.21.0";

  src = fetchFromGitHub {
    owner = "FelixKratz";
    repo = "SketchyBar";
    rev = "v${finalAttrs.version}";
    hash = "sha256-hTfQQjx6ai83zYFfccsz/KaoZUIj5Dfz4ENe59gS02E=";
  };

  buildInputs = [
    AppKit
    Carbon
    CoreAudio
    CoreWLAN
    CoreVideo
    DisplayServices
    IOKit
    MediaRemote
    SkyLight
  ];

  makeFlags = [
    target
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp ./bin/sketchybar $out/bin/sketchybar

    runHook postInstall
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      version = "sketchybar-v${finalAttrs.version}";
    };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "A highly customizable macOS status bar replacement";
    homepage = "https://github.com/FelixKratz/SketchyBar";
    license = lib.licenses.gpl3;
    mainProgram = "sketchybar";
    maintainers = with lib.maintainers; [ azuwis khaneliman ];
    platforms = lib.platforms.darwin;
  };
})
