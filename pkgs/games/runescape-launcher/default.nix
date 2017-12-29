{ stdenv, newScope }:

let
  callPackage = newScope self;
  self = {
    runescape-launcher-runtime = callPackage ./runtime.nix {};
    runescape-launcher-wrapper = callPackage ./wrapper.nix {};
  };
in

with self;

stdenv.mkDerivation rec {
  name = "runescape-launcher-${version}";
  version = runescape-launcher-runtime.version;

  buildInputs = [
    runescape-launcher-runtime
    runescape-launcher-wrapper
  ];

  unpackPhase = ":";

  installPhase = ''
    mkdir -p $out/bin
    ln -s ${runescape-launcher-wrapper}/bin/${runescape-launcher-wrapper.name} $out/bin/runescape-launcher
    ln -s ${runescape-launcher-runtime}/share $out/share
  '';
}
