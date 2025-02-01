pkgs: {
  percona-server_lts = pkgs.callPackage ./lts.nix {
    inherit (pkgs.darwin) developer_cmds DarwinTools;
    inherit (pkgs.darwin.apple_sdk.frameworks) CoreServices;
    boost = pkgs.boost177; # Configure checks for specific version.
    icu = pkgs.icu69;
    protobuf = pkgs.protobuf_21;
  };
  percona-server_innovation = pkgs.callPackage ./innovation.nix {
    inherit (pkgs.darwin) developer_cmds DarwinTools;
    inherit (pkgs.darwin.apple_sdk.frameworks) CoreServices;
    # newer versions cause linking failures against `libabsl_spinlock_wait`
    protobuf = pkgs.protobuf_21;
  };
}
