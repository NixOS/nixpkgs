{ lib, stdenv, fetchFromGitHub, Carbon, Cocoa, CoreWLAN, DisplayServices, MediaRemote, SkyLight }:

let
  inherit (stdenv.hostPlatform) system;
  target = {
    "aarch64-darwin" = "arm64";
    "x86_64-darwin" = "x86";
  }.${system} or (throw "Unsupported system: ${system}");
in

stdenv.mkDerivation rec {
  pname = "sketchybar";
  version = "2.15.2";

  src = fetchFromGitHub {
    owner = "FelixKratz";
    repo = "SketchyBar";
    rev = "v${version}";
    hash = "sha256-13wc+1IgplB+L0j1AbBr/MUjEo4W38ZgJwrAhbdOroE=
";
  };

  buildInputs = [ Carbon Cocoa CoreWLAN DisplayServices MediaRemote SkyLight ];

  makeFlags = [
    target
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp ./bin/sketchybar $out/bin/sketchybar
  '';

  meta = with lib; {
    description = "A highly customizable macOS status bar replacement";
    homepage = "https://github.com/FelixKratz/SketchyBar";
    platforms = platforms.darwin;
    maintainers = with maintainers; [ azuwis khaneliman ];
    license = licenses.gpl3;
  };
}
