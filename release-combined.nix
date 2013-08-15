{ nixosSrc ? { outPath = ./.; revCount = 1234; shortRev = "abcdefg"; }
, nixpkgs ? { outPath = <nixpkgs>; revCount = 5678; shortRev = "gfedcba"; }
, officialRelease ? false
}:

let
  nixpkgs' = nixpkgs; # urgh

  pkgs = import <nixpkgs> {};

  removeMaintainers = set: if builtins.isAttrs set
    then if (set.type or "") == "derivation"
      then set // { meta = builtins.removeAttrs (set.meta or {}) [ "maintainers" ]; }
      else pkgs.lib.mapAttrs (n: v: removeMaintainers v) set
    else set;
in rec {
  nixos = removeMaintainers (import ./release.nix {
    inherit nixosSrc officialRelease;
    nixpkgs = nixpkgs';
  });

  nixpkgs = removeMaintainers (import <nixpkgs/pkgs/top-level/release.nix> {
    inherit officialRelease;
    nixpkgs = nixpkgs';
    # Only do Linux builds.
    supportedSystems = [ "x86_64-linux" "i686-linux" ];
  });

  tested = pkgs.releaseTools.aggregate {
    name = "nixos-${nixos.tarball.version}";
    meta = {
      description = "Release-critical builds for the NixOS unstable channel";
      maintainers = [ pkgs.lib.maintainers.shlevy ];
    };
    constituents =
      [ nixos.channel
        nixos.manual

        nixos.iso_minimal.x86_64-linux
        nixos.iso_minimal.i686-linux
        nixos.iso_graphical.x86_64-linux
        nixos.iso_graphical.i686-linux

        nixos.tests.firefox.x86_64-linux
        nixos.tests.firewall.x86_64-linux
        nixos.tests.installer.lvm.x86_64-linux
        nixos.tests.installer.separateBoot.x86_64-linux
        nixos.tests.installer.simple.i686-linux
        nixos.tests.installer.simple.x86_64-linux
        nixos.tests.kde4.i686-linux
        nixos.tests.login.i686-linux
        nixos.tests.login.x86_64-linux
        nixos.tests.misc.i686-linux
        nixos.tests.misc.x86_64-linux

        nixpkgs.tarball
        nixpkgs.emacs.i686-linux
        nixpkgs.emacs.x86_64-linux
      ];
  };

}
