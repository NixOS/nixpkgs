pkgs: {
  percona-xtrabackup_8_0 = pkgs.callPackage ./8_0.nix {
    boost = pkgs.boost177;
  };
  percona-xtrabackup_8_4 = pkgs.callPackage ./8_4.nix { };
  percona-xtrabackup = pkgs.percona-xtrabackup_8_4;
}
