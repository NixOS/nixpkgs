{ stdenv, hostPlatform, fetchFromGitHub, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  mptcpVersion = "0.93";
  modDirVersion = "4.9.60";
  version = "${modDirVersion}-mptcp_v${mptcpVersion}";

  extraMeta = {
    branch = "4.4";
    maintainers = with stdenv.lib.maintainers; [ teto layus ];
  };

  src = fetchFromGitHub {
    owner = "multipath-tcp";
    repo = "mptcp";
    rev = "v${mptcpVersion}";
    sha256 = "1irlppzvcmckrazs2c4vg6y8ji31552izc3wqabf401v57jvxcys";
  };

  extraConfig = ''
    IPV6 y
    MPTCP y
    IP_MULTIPLE_TABLES y

    # Enable advanced path-managers...
    MPTCP_PM_ADVANCED y
    MPTCP_FULLMESH y
    MPTCP_NDIFFPORTS y
    # ... but use none by default.
    # The default is safer if source policy routing is not setup.
    DEFAULT_DUMMY y
    DEFAULT_MPTCP_PM default

    # MPTCP scheduler selection.
    # Disabled as the only non-default is the useless round-robin.
    MPTCP_SCHED_ADVANCED n
    DEFAULT_MPTCP_SCHED default

    # Smarter TCP congestion controllers
    TCP_CONG_LIA m
    TCP_CONG_OLIA m
    TCP_CONG_WVEGAS m
    TCP_CONG_BALIA m

  '' + (args.extraConfig or "");
} // (args.argsOverride or {}))
