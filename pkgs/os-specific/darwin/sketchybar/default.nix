{ lib, stdenv, fetchFromGitHub, Carbon, Cocoa, CoreWLAN, DisplayServices, SkyLight }:

let
  inherit (stdenv.hostPlatform) system;
  target = {
    "aarch64-darwin" = "arm64";
    "x86_64-darwin" = "x86";
  }.${system} or (throw "Unsupported system: ${system}");
in

stdenv.mkDerivation rec {
  pname = "sketchybar";
  version = "2.14.4";

  src = fetchFromGitHub {
    owner = "FelixKratz";
    repo = "SketchyBar";
    rev = "v${version}";
    hash = "sha256-snB1DII04OeoPbLzblfgdaM1hdXL62u/g/0CNLmqrxo=";
  };

  buildInputs = [ Carbon Cocoa CoreWLAN DisplayServices SkyLight ];

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
    maintainers = [ maintainers.azuwis ];
    license = licenses.gpl3;
  };
}
