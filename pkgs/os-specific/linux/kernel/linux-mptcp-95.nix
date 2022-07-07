{ lib, buildPackages, fetchFromGitHub, perl, buildLinux, structuredExtraConfig ? {}, ... } @ args:
let
  mptcpVersion = "0.95.1";
  modDirVersion = "4.19.126";
in
buildLinux ({
  version = "${modDirVersion}-mptcp_v${mptcpVersion}";
  inherit modDirVersion;

  extraMeta = {
    branch = "4.19";
    maintainers = with lib.maintainers; [ teto layus ];
  };

  src = fetchFromGitHub {
    owner = "multipath-tcp";
    repo = "mptcp";
    rev = "v${mptcpVersion}";
    sha256 = "sha256-J9UXhkI49cq83EtojLHieRtp8fT3LXTJNIqb+mUwZdM=";
  };

  structuredExtraConfig = lib.mkMerge [
    (import ./mptcp-config.nix { inherit lib; })
    structuredExtraConfig
  ];

} // args)
