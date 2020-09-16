{ stdenv, pkgs }:
let
  inherit (import ./build-chromium-extension.nix { inherit stdenv pkgs; }) buildChromiumExtension;
in {
  bypass-paywalls = pkgs.callPackage ./extensions/bypass-paywalls { inherit buildChromiumExtension; };

  decentraleyes = pkgs.callPackage ./extensions/decentraleyes { inherit buildChromiumExtension; };

  https-everywhere = pkgs.callPackage ./extensions/https-everywhere { inherit buildChromiumExtension; };

  ublock-origin = pkgs.callPackage ./extensions/ublock-origin { inherit buildChromiumExtension; };
}
