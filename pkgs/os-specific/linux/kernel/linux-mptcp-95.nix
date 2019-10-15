{ stdenv, buildPackages, fetchFromGitHub, perl, buildLinux, structuredExtraConfig ? {}, ... } @ args:
let
  mptcpVersion = "0.95";
  modDirVersion = "4.19.55";
in
buildLinux ({
  version = "${modDirVersion}-mptcp_v${mptcpVersion}";
  inherit modDirVersion;

  extraMeta = {
    branch = "4.19";
    maintainers = with stdenv.lib.maintainers; [ teto layus ];
  };

  src = fetchFromGitHub {
    owner = "multipath-tcp";
    repo = "mptcp";
    rev = "v${mptcpVersion}";
    sha256 = "04a66iq5vsiz8mkpszfxmqknz7y4w3lsckrcz6q1syjpk0pdyiyw";
  };

  structuredExtraConfig = stdenv.lib.mkMerge [
    (import ./mptcp-config.nix { inherit stdenv; })
    structuredExtraConfig
  ];

} // args)
