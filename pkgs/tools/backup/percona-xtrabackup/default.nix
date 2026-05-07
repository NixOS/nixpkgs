pkgs: {
  percona-xtrabackup_8_4 = pkgs.callPackage ./8_4.nix { };
  percona-xtrabackup = pkgs.percona-xtrabackup_8_4;
}
