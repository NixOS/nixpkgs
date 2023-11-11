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
  version = "2.19.1";

  src = fetchFromGitHub {
    owner = "FelixKratz";
    repo = "SketchyBar";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Ge15Df65fvNJ8ZdJ8giqvYytIivup2IIFPS+Ie3Yl9A=";
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

  # NOTE: Release didn't bump patch version remove with next release
  postPatch = ''
    substituteInPlace src/sketchybar.c \
      --replace "#define PATCH 0" "#define PATCH 1"
  '';

  makeFlags = [
    target
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp ./bin/sketchybar $out/bin/sketchybar

    runHook postInstall
  '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    version = "sketchybar-v${finalAttrs.version}";
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
