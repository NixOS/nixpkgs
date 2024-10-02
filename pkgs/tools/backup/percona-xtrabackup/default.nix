pkgs: {
  percona-xtrabackup_lts = pkgs.callPackage ./lts.nix {
    boost = pkgs.boost177;
  };
  percona-xtrabackup_innovation = pkgs.callPackage ./innovation.nix { };
}
