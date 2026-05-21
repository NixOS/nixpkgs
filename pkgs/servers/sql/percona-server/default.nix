pkgs: {
  percona-server_8_4 = pkgs.callPackage ./8_4.nix {
    inherit (pkgs.darwin) developer_cmds DarwinTools;
    # newer versions cause linking failures against `libabsl_spinlock_wait`
    protobuf = pkgs.protobuf_21;
  };
  percona-server = pkgs.percona-server_8_4;
}
