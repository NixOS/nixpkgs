{ lib, stdenv, fetchFromGitHub, buildLinux, variant, ... } @ args:

let
  # comments with variant added for update script
  variants = {
    # ./update-zen.py zen
    zen = {
      version = "6.10.5"; #zen
      suffix = "zen1"; #zen
      sha256 = "08ibz7560xsmlnrm8j13hxf8hjjcxfmnjdrwffqc81g9g6rvpqra"; #zen
      isLqx = false;
    };
    # ./update-zen.py lqx
    lqx = {
      version = "6.10.5"; #lqx
      suffix = "lqx1"; #lqx
      sha256 = "09rscj20j94qkmvk0hlpjm6v1n1ndnkv2vl035gsp5lwggws2jqm"; #lqx
      isLqx = true;
    };
  };
  zenKernelsFor = { version, suffix, sha256, isLqx }: buildLinux (args // {
    inherit version;
    pname = "linux-${if isLqx then "lqx" else "zen"}";
    modDirVersion = lib.versions.pad 3 "${version}-${suffix}";
    isZen = true;

    src = fetchFromGitHub {
      owner = "zen-kernel";
      repo = "zen-kernel";
      rev = "v${version}-${suffix}";
      inherit sha256;
    };

    # This is based on the following sources:
    # - zen: https://gitlab.archlinux.org/archlinux/packaging/packages/linux-zen/-/blob/main/config
    # - lqx: https://github.com/damentz/liquorix-package/blob/6.8/master/linux-liquorix/debian/config/kernelarch-x86/config-arch-64
    # - Liquorix features: https://liquorix.net/
    # The list below is not exhaustive, so the kernels probably doesn't match
    # the upstream, but should bring most of the improvements that will be
    # expected by users
    structuredExtraConfig = with lib.kernel; {
      # Zen Interactive tuning
      ZEN_INTERACTIVE = yes;

      # FQ-Codel Packet Scheduling
      NET_SCH_DEFAULT = yes;
      DEFAULT_FQ_CODEL = yes;

      # Preempt (low-latency)
      PREEMPT = lib.mkOverride 60 yes;
      PREEMPT_VOLUNTARY = lib.mkOverride 60 no;

      # Preemptible tree-based hierarchical RCU
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
      RCU_BOOST = yes;
      RCU_BOOST_DELAY = option (freeform "500");
      RCU_NOCB_CPU = yes;
      RCU_LAZY = yes;
      RCU_DOUBLE_CHECK_CB_TIME = yes;

      # BFQ I/O scheduler
      IOSCHED_BFQ = lib.mkOverride 60 yes;

      # Futex WAIT_MULTIPLE implementation for Wine / Proton Fsync.
      FUTEX = yes;
      FUTEX_PI = yes;

      # NT synchronization primitive emulation
      NTSYNC = yes;

      # Preemptive Full Tickless Kernel at 1000Hz
      HZ = freeform "1000";
      HZ_1000 = yes;

      # Alternative zpool for zswap
      Z3FOLD = yes;
    } // lib.optionalAttrs (isLqx) {
      # Google's BBRv3 TCP congestion Control
      TCP_CONG_BBR = yes;
      DEFAULT_BBR = yes;

      # PDS Process Scheduler
      SCHED_ALT = yes;
      SCHED_PDS = yes;

      # https://github.com/damentz/liquorix-package/commit/a7055b936c0f4edb8f6afd5263fe1d2f8a5cd877
      RCU_BOOST = no;
      RCU_LAZY = lib.mkOverride 60 no;

      # Swap storage is compressed with LZ4 using zswap
      ZSWAP_COMPRESSOR_DEFAULT_LZ4  = lib.mkOptionDefault yes;
      ZSWAP_COMPRESSOR_DEFAULT_ZSTD = lib.mkDefault no;
      ZSWAP_ZPOOL_DEFAULT_Z3FOLD = yes;

      # Fix error: unused option: XXX.
      CFS_BANDWIDTH = lib.mkForce (option no);
      PSI = lib.mkForce (option no);
      RT_GROUP_SCHED = lib.mkForce (option no);
      SCHED_AUTOGROUP = lib.mkForce (option no);
      SCHED_CORE = lib.mkForce (option no);
      UCLAMP_TASK = lib.mkForce (option no);
      UCLAMP_TASK_GROUP = lib.mkForce (option no);
    };

    passthru.updateScript = [ ./update-zen.py (if isLqx then "lqx" else "zen") ];

    extraMeta = {
      branch = lib.versions.majorMinor version + "/master";
      maintainers = with lib.maintainers; [ thiagokokada jerrysm64 ];
      description = "Built using the best configuration and kernel sources for desktop, multimedia, and gaming workloads." +
        lib.optionalString isLqx " (Same as linux_zen, but less aggressive release schedule and additional extra config)";
      broken = stdenv.isAarch64;
    };

  } // (args.argsOverride or { }));
in
zenKernelsFor variants.${variant}
