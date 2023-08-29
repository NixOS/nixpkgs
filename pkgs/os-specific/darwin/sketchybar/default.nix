{ lib
, stdenv
, fetchFromGitHub
, AppKit
, CoreAudio
, CoreWLAN
, CoreVideo
, DisplayServices
, IOKit
, MediaRemote
, SkyLight
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
  version = "2.16.1";

  src = fetchFromGitHub {
    owner = "FelixKratz";
    repo = "SketchyBar";
    rev = "v${finalAttrs.version}";
    hash = "sha256-H+bR5ZhUTrN2KAEdY/hnq6c3TEb1NQvPQ9uPo09gSM8=";
  };

  buildInputs = [
    AppKit
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

  meta = {
    description = "A highly customizable macOS status bar replacement";
    homepage = "https://github.com/FelixKratz/SketchyBar";
    license = lib.licenses.gpl3;
    mainProgram = "sketchybar";
    maintainers = with lib.maintainers; [ azuwis khaneliman ];
    platforms = lib.platforms.darwin;
  };
})
