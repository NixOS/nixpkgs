{ pkgs ? import ../. {} }:
rec {
  test-lib = import ./lib { inherit pkgs; };

  callTest = pkgs.newScope test-lib;

  maxima = callTest ./maxima.nix {};
  libreoffice = callTest ./libreoffice.nix {};
  pdf = callTest ./latex-zathura.nix {};

  coreutils-versions = test-lib.checkAllExecutables pkgs.coreutils {
    skipRegex = "(false|test)";
  };
}
