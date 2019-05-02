{ stdenv, buildPackages, fetchFromGitHub, perl, buildLinux, structuredExtraConfig ? {}, ... } @ args:
let
  mptcpVersion = "0.94.4";
  modDirVersion = "4.14.110";
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
    sha256 = "1ng6p1djhm3m5g44yyq7gpqqbzsnhm9rimsafp5g4dx8cm27a70f";
  };

  structuredExtraConfig = with import ../../../../lib/kernel.nix { inherit (stdenv) lib; version = null; };
    stdenv.lib.mkMerge [ {
    IPV6               = yes;
    MPTCP              = yes;
    IP_MULTIPLE_TABLES = yes;

    # Enable advanced path-managers...
    MPTCP_PM_ADVANCED = yes;
    MPTCP_FULLMESH = yes;
    MPTCP_NDIFFPORTS = yes;
    # ... but use none by default.
    # The default is safer if source policy routing is not setup.
    DEFAULT_DUMMY = yes;
    DEFAULT_MPTCP_PM.freeform = "default";

    # MPTCP scheduler selection.
    MPTCP_SCHED_ADVANCED = yes;
    DEFAULT_MPTCP_SCHED.freeform = "default";

    # Smarter TCP congestion controllers
    TCP_CONG_LIA = module;
    TCP_CONG_OLIA = module;
    TCP_CONG_WVEGAS = module;
    TCP_CONG_BALIA = module;
  }
  structuredExtraConfig
  ];
} // args)
