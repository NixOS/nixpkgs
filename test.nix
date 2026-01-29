let
  pkgs = import ./. {
    config.allowUnfree = true;
  };
in
pkgs.mathematica.override {
  version = "14.3.0";
  webdoc = true;
}
