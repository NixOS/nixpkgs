let
  pkgs = import ../../.. {
    config = {};
    overlays = [];
  };
in pkgs.tests.nixpkgs-check-by-name.shell
