{ lib, stdenv, fetchFromGitHub, memstreamHook, Carbon, Cocoa, SkyLight }:

let
  inherit (stdenv.hostPlatform) system;
  target = {
    "aarch64-darwin" = "arm";
    "x86_64-darwin" = "x86";
  }.${system} or (throw "Unsupported system: ${system}");
in

stdenv.mkDerivation rec {
  pname = "sketchybar";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "FelixKratz";
    repo = "SketchyBar";
    rev = "v${version}";
    sha256 = "sha256-ucTyJhRhSVyE4E/x6PtFz7nHRUg6cKKVOrRpPs39iO8=";
  };

  buildInputs = [ Carbon Cocoa SkyLight ]
    ++ lib.optionals (stdenv.system == "x86_64-darwin") [ memstreamHook ];

  makeFlags = [
    target
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp ./bin/sketchybar_${target} $out/bin/sketchybar
  '';

  meta = with lib; {
    description = "A highly customizable macOS status bar replacement";
    homepage = "https://github.com/FelixKratz/SketchyBar";
    platforms = platforms.darwin;
    maintainers = [ maintainers.azuwis ];
    license = licenses.gpl3;
  };
}
