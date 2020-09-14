{ stdenv, pkgs }:
let
  inherit (import ./build-chromium-extension.nix { inherit stdenv pkgs; }) buildChromiumExtension;
in {
}
