pkgs: {
  percona-xtrabackup_8_4 = pkgs.callPackage ./8_4.nix { };
  percona-xtrabackup_9_7 = pkgs.callPackage ./9_7.nix { };
  percona-xtrabackup = pkgs.percona-xtrabackup_8_4;
}
