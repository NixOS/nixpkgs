{
  lib,
  stdenv,
  fetchFromGitHub,
  buildLinux,
  ...
}@args:

let
  # Default priority is 100 for common kernel options (see common-config.nix
  # file), we need something lower to override them, but we still want users to
  # override options if they need using lib.mkForce (that has 50 priority)
  mkKernelOverride = lib.mkOverride 90;

  suffix = "zen1";
in

buildLinux (
  args
  // rec {
    version = "7.0.5";
    pname = "linux-zen";
    modDirVersion = lib.versions.pad 3 "${version}-${suffix}";
    isZen = true;

    src = fetchFromGitHub {
      owner = "zen-kernel";
      repo = "zen-kernel";
      rev = "v${version}-${suffix}";
      sha256 = "1xnxjknlsx4fr6jf62ncvnad7r7nxkjpkaj9fdj0fqq8h4bpkhh1";
    };

    # This is based on the following source:
    # https://gitlab.archlinux.org/archlinux/packaging/packages/linux-zen/-/blob/main/config
    # The list below is not exhaustive, so the kernel probably doesn't match
    # the upstream, but should bring most of the improvements that will be
    # expected by users
    structuredExtraConfig = with lib.kernel; {
      # Zen Interactive tuning
      ZEN_INTERACTIVE = yes;

      # FQ-Codel Packet Scheduling
      NET_SCH_DEFAULT = yes;
      DEFAULT_FQ_CODEL = yes;

      # Preempt (low-latency)
      PREEMPT = mkKernelOverride yes;
      PREEMPT_LAZY = mkKernelOverride no;

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
      IOSCHED_BFQ = mkKernelOverride yes;

      # Futex WAIT_MULTIPLE implementation for Wine / Proton Fsync.
      FUTEX = yes;
      FUTEX_PI = yes;

      # NT synchronization primitive emulation
      NTSYNC = yes;

      # Preemptive Full Tickless Kernel at 1000Hz
      HZ = freeform "1000";
      HZ_1000 = yes;
    };

    extraPassthru.updateScript = [
      ./update-zen.py
    ];

    extraMeta = {
      branch = lib.versions.majorMinor version + "/master";
      maintainers = with lib.maintainers; [
        thiagokokada
        jerrysm64
        axertheaxe
      ];
      teams = [ ];
      description = "Built using the best configuration and kernel sources for desktop, multimedia, and gaming workloads.";
      broken = stdenv.hostPlatform.isAarch64;
    };

  }
  // (args.argsOverride or { })
)
