{ stdenv }:
with stdenv.lib.kernel;
{
    # DRM_AMDGPU = yes;

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
