pkgs: {
  percona-xtrabackup_8_0 = pkgs.callPackage ./8_0.nix {
    boost = pkgs.boost177;
  };
  percona-xtrabackup_8_3 = pkgs.callPackage ./8_3.nix { };
}
