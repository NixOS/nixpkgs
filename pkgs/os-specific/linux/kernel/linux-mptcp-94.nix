{ stdenv, buildPackages, fetchFromGitHub, perl, buildLinux, structuredExtraConfig ? {}, ... } @ args:
let
  mptcpVersion = "0.94.6";
  modDirVersion = "4.14.127";
in
buildLinux ({
  version = "${modDirVersion}-mptcp_v${mptcpVersion}";
  inherit modDirVersion;

  extraMeta = {
    branch = "4.4";
    maintainers = with stdenv.lib.maintainers; [ teto layus ];
  };

  src = fetchFromGitHub {
    owner = "multipath-tcp";
    repo = "mptcp";
    rev = "v${mptcpVersion}";
    sha256 = "071cx9205wpzhi5gc2da79w2abs3czd60jg0xml7j1szc5wl4yfn";
  };

  structuredExtraConfig = stdenv.lib.mkMerge [
    (import ./mptcp-config.nix { inherit stdenv; })
    structuredExtraConfig
  ];
} // args)
