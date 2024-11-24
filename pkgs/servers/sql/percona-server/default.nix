pkgs: {
  # old lts
  percona-server_8_0 = pkgs.callPackage ./8_0.nix {
    inherit (pkgs.darwin) developer_cmds DarwinTools;
    inherit (pkgs.darwin.apple_sdk.frameworks) CoreServices;
    boost = pkgs.boost177; # Configure checks for specific version.
    icu = pkgs.icu69;
    # newer versions cause linking failures against `libabsl_spinlock_wait`
    protobuf = pkgs.protobuf_21;
  };
  percona-server_8_4 = pkgs.callPackage ./8_4.nix {
    inherit (pkgs.darwin) developer_cmds DarwinTools;
    inherit (pkgs.darwin.apple_sdk.frameworks) CoreServices;
    # newer versions cause linking failures against `libabsl_spinlock_wait`
    protobuf = pkgs.protobuf_21;
  };
  percona-server = pkgs.percona-server_8_4;
}
