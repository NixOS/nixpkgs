{ stdenv, buildPackages, fetchFromGitHub, perl, buildLinux, ... } @ args:

buildLinux (rec {
  mptcpVersion = "0.94.1";
  modDirVersion = "4.14.70";
  version = "${modDirVersion}-mptcp_v${mptcpVersion}";
  # autoModules= true;

  extraMeta = {
    branch = "4.4";
    maintainers = with stdenv.lib.maintainers; [ teto layus ];
  };

  src = fetchFromGitHub {
    owner = "multipath-tcp";
    repo = "mptcp";
    rev = "v${mptcpVersion}";
    sha256 = "13mi672jr1x463kzig1hi9cpdi8x6nqdfd4bqlrjn8zca48f4ln4";
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
    MPTCP_SCHED_ADVANCED y
    DEFAULT_MPTCP_SCHED default

    # Smarter TCP congestion controllers
    TCP_CONG_LIA m
    TCP_CONG_OLIA m
    TCP_CONG_WVEGAS m
    TCP_CONG_BALIA m

  '' + (args.extraConfig or "");
} // args)
