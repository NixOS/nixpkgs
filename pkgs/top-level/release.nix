let

  allPackages = import ./all-packages.nix;

  pkgs = {
    inherit (allPackages {system = "i686-linux";})
      bash
      gcc
      ;
    hello = {system}: (allPackages {inherit system;}).hello;
    pan = {system}: (allPackages {inherit system;}).pan;
  };

in pkgs
