{
  callPackage,
  lib,
  pkgs,
  ...
}:

(import ../autocalling-package-set.nix {
  inherit callPackage lib;
  baseDirectory = ./.;
}) // lib.optionalAttrs pkgs.config.allowAliases {
  android-tv-card = lib.warn "`home-assistant-custom-lovelace-modules.android-tv-card` has been renamed to `universal-remote-card`" pkgs.home-assistant-custom-lovelace-modules.universal-remote-card;
}
