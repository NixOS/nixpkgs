{ lib, stdenv, fetchFromGitHub, Carbon, Cocoa, SkyLight }:

let
  inherit (stdenv.hostPlatform) system;
  target = {
    "aarch64-darwin" = "arm";
    "x86_64-darwin" = "x86";
  }.${system} or (throw "Unsupported system: ${system}");
in

stdenv.mkDerivation rec {
  pname = "sketchybar";
  version = "2.4.3";

  src = fetchFromGitHub {
    owner = "FelixKratz";
    repo = "SketchyBar";
    rev = "v${version}";
    sha256 = "1370xjl8sas5nghxgjxmc1zgskf28g40pv7nxgh37scjwdrkrrvb";
  };

  buildInputs = [ Carbon Cocoa SkyLight ];

  postPatch = ''
    sed -i -e '/^#include <malloc\/_malloc.h>/d' src/*.[ch] src/*/*.[ch]
  '';

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
