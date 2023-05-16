<<<<<<< HEAD
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
=======
{ lib, stdenv, fetchFromGitHub, Carbon, Cocoa, CoreWLAN, DisplayServices, SkyLight }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

let
  inherit (stdenv.hostPlatform) system;
  target = {
    "aarch64-darwin" = "arm64";
    "x86_64-darwin" = "x86";
  }.${system} or (throw "Unsupported system: ${system}");
in
<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
  pname = "sketchybar";
  version = "2.16.3";
=======

stdenv.mkDerivation rec {
  pname = "sketchybar";
  version = "2.15.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "FelixKratz";
    repo = "SketchyBar";
<<<<<<< HEAD
    rev = "v${finalAttrs.version}";
    hash = "sha256-PCAGIcO7lvIAEFXlJn/e9zG5kxvDABshxFbu/bXWX7o=";
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
=======
    rev = "v${version}";
    hash = "sha256-0jCVDaFc7ZvA8apeHRoQvPhAlaGlBHzqUkS9or88PcM=";
  };

  buildInputs = [ Carbon Cocoa CoreWLAN DisplayServices SkyLight ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  makeFlags = [
    target
  ];

  installPhase = ''
<<<<<<< HEAD
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
=======
    mkdir -p $out/bin
    cp ./bin/sketchybar $out/bin/sketchybar
  '';

  meta = with lib; {
    description = "A highly customizable macOS status bar replacement";
    homepage = "https://github.com/FelixKratz/SketchyBar";
    platforms = platforms.darwin;
    maintainers = [ maintainers.azuwis ];
    license = licenses.gpl3;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
