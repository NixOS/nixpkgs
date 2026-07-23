{
  lib,
  fetchFromGitHub,
  buildLinux,
  ...
}@args:

let
  # Common kernel options use priority 100. Liquorix policy must win over those
  # defaults while still allowing users to override it with lib.mkForce.
  mkKernelOverride = lib.mkOverride 90;
  suffix = "lqx1";
in

buildLinux (
  args
  // rec {
    pname = "linux-lqx";
    version = "7.1.4";
    modDirVersion = lib.versions.pad 3 "${version}-${suffix}";
    isZen = true;

    src = fetchFromGitHub {
      owner = "zen-kernel";
      repo = "zen-kernel";
      rev = "v${version}-${suffix}";
      sha256 = "1g14af9957vynr66cd3cgvi2b0i7gakdvy6nn5rw6q0gc0b5xhps";
    };

    # Keep this to Liquorix-specific policy. Hardware enablement continues to
    # come from the Nixpkgs kernel configuration.
    structuredExtraConfig = with lib.kernel; {
      ZEN_INTERACTIVE = yes;

      # Low-latency scheduling and timer policy.
      PREEMPT = mkKernelOverride yes;
      PREEMPT_LAZY = mkKernelOverride no;
      PREEMPT_DYNAMIC = mkKernelOverride no;
      NO_HZ_FULL = mkKernelOverride yes;
      NO_HZ_IDLE = mkKernelOverride no;
      HZ = freeform "1000";
      HZ_1000 = yes;

      # Project C scheduler used by Liquorix.
      SCHED_ALT = yes;
      SCHED_PDS = yes;
      CFS_BANDWIDTH = yes;
      PSI = yes;
      RT_GROUP_SCHED = mkKernelOverride yes;

      # These Nixpkgs defaults are unavailable with the alternative scheduler.
      SCHED_AUTOGROUP = mkKernelOverride (option no);
      SCHED_CLASS_EXT = mkKernelOverride (option no);
      SCHED_CORE = mkKernelOverride (option no);
      THERMAL_GOV_POWER_ALLOCATOR = mkKernelOverride (option no);

      # Preemptible tree-based hierarchical RCU.
      TREE_RCU = yes;
      PREEMPT_RCU = yes;
      RCU_EXPERT = yes;
      TREE_SRCU = yes;
      TASKS_RCU_GENERIC = yes;
      TASKS_RCU = yes;
      TASKS_RUDE_RCU = yes;
      TASKS_TRACE_RCU = yes;
      RCU_STALL_COMMON = yes;
      RCU_NEED_SEGCBLIST = yes;
      RCU_FANOUT = freeform "64";
      RCU_FANOUT_LEAF = freeform "16";
      RCU_BOOST = mkKernelOverride no;
      RCU_NOCB_CPU = yes;
      RCU_NOCB_CPU_DEFAULT_ALL = yes;
      RCU_LAZY = mkKernelOverride no;
      RCU_DOUBLE_CHECK_CB_TIME = yes;

      # Desktop, gaming, storage, and network latency policy.
      IOSCHED_BFQ = mkKernelOverride yes;
      FUTEX = yes;
      FUTEX_PI = yes;
      NTSYNC = yes;
      NET_SCH_DEFAULT = yes;
      DEFAULT_FQ_CODEL = yes;
      TCP_CONG_BBR3 = yes;
      DEFAULT_BBR3 = yes;
      ZSWAP_COMPRESSOR_DEFAULT_LZ4 = yes;
      ZSWAP_COMPRESSOR_DEFAULT_ZSTD = mkKernelOverride no;
      SLAB_BUCKETS = yes;
      WQ_POWER_EFFICIENT_DEFAULT = yes;
      ENERGY_MODEL = mkKernelOverride (option no);

      # This is a fallback command line. CMDLINE_OVERRIDE remains disabled, so
      # the command line supplied by the NixOS boot loader takes precedence.
      CMDLINE_BOOL = yes;
      CMDLINE = freeform "audit=0 intel_pstate=disable amd_pstate=disable split_lock_detect=off ";
      CMDLINE_OVERRIDE = mkKernelOverride no;
    };

    extraPassthru.updateScript = {
      command = [ ./update-liquorix.py ];
      attrPath = "linux_lqx";
      supportedFeatures = [ "commit" ];
    };

    extraMeta = {
      branch = lib.versions.majorMinor version + "/master";
      description = "Liquorix kernel for desktop, multimedia, and gaming workloads";
      homepage = "https://liquorix.net/";
      maintainers = with lib.maintainers; [ cheerfulScumbag ];
      platforms = [ "x86_64-linux" ];
      teams = [ ];
    };
  }
  // (args.argsOverride or { })
)
