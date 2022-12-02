{ lib, stdenv, fetchFromGitHub, memstreamHook, Carbon, Cocoa, SkyLight, DisplayServices }:

let
  inherit (stdenv.hostPlatform) system;
  target = {
    "aarch64-darwin" = "arm64";
    "x86_64-darwin" = "x86";
  }.${system} or (throw "Unsupported system: ${system}");
in

stdenv.mkDerivation rec {
  pname = "sketchybar";
  version = "2.11.2";

  src = fetchFromGitHub {
    owner = "FelixKratz";
    repo = "SketchyBar";
    rev = "v${version}";
    sha256 = "sha256-vVOO4rAEp8/h6lkqDwn44GZYIEBrkqsuoDSz3aZs+pQ=";
  };

  buildInputs = [ Carbon Cocoa DisplayServices SkyLight ]
    ++ lib.optionals (stdenv.system == "x86_64-darwin") [ memstreamHook ];

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
