{
  lib,
  stdenv,
  fetchFromGitHub,
  buildLinux,
  variant,
  ...
}@args:

let
  # Default priority is 100 for common kernel options (see common-config.nix
  # file), we need something lower to override them, but we still want users to
  # override options if they need using lib.mkForce (that has 50 priority)
  mkKernelOverride = lib.mkOverride 90;
  # Comments with variant added for update script
  variants = {
    # ./update-zen.py zen
    zen = {
      version = "6.17.9"; # zen
      suffix = "zen1"; # zen
      sha256 = "0xrmhs2kabiszdldqx7c4bj3zicbslvvgmw8j77zlc49zddxhz1q"; # zen
      isLqx = false;
    };
    # ./update-zen.py lqx
    lqx = {
      version = "6.17.9"; # lqx
      suffix = "lqx1"; # lqx
      sha256 = "0c1b73yzj5g783qrz3pydq2ilk57bmb867y48spxr1jxncxml8dz"; # lqx
      isLqx = true;
    };
  };
  zenKernelsFor =
    {
      version,
      suffix,
      sha256,
      isLqx,
    }:
    buildLinux (
      args
      // {
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
        # - lqx: https://github.com/damentz/liquorix-package/blob/6.13/master/linux-liquorix/debian/config/kernelarch-x86/config-arch-64
        # - Liquorix features: https://liquorix.net/
        # The list below is not exhaustive, so the kernels probably doesn't match
        # the upstream, but should bring most of the improvements that will be
        # expected by users
        structuredExtraConfig =
          with lib.kernel;
          {
            # Zen Interactive tuning
            ZEN_INTERACTIVE = yes;

            # FQ-Codel Packet Scheduling
            NET_SCH_DEFAULT = yes;
            DEFAULT_FQ_CODEL = yes;

            # Preempt (low-latency)
            PREEMPT = mkKernelOverride yes;
            PREEMPT_VOLUNTARY = mkKernelOverride no;

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

          }
          // lib.optionalAttrs isLqx {
            # https://github.com/damentz/liquorix-package/commit/07b176edc002f2a7825ae181613e1f79a3650fd2
            CMDLINE_BOOL = yes;
            CMDLINE = freeform "audit=0 intel_pstate=disable amd_pstate=disable ";

            # Google's BBRv3 TCP congestion Control
            TCP_CONG_BBR = yes;
            DEFAULT_BBR = yes;

            # PDS Process Scheduler
            SCHED_ALT = yes;
            SCHED_PDS = yes;

            # https://github.com/damentz/liquorix-package/commit/a7055b936c0f4edb8f6afd5263fe1d2f8a5cd877
            RCU_BOOST = no;
            RCU_LAZY = mkKernelOverride no;

            # Swap storage is compressed with LZ4 using zswap
            ZSWAP_COMPRESSOR_DEFAULT_LZ4 = yes;
            ZSWAP_COMPRESSOR_DEFAULT_ZSTD = mkKernelOverride no;

            # https://github.com/damentz/liquorix-package/commit/3a82381a4db3452599e2b2a607046a379c72ad27
            SLAB_BUCKETS = mkKernelOverride (option no);
            # https://github.com/damentz/liquorix-package/commit/ca7efe07abd478f3f4cbe0725a3383fd235aa5be
            ENERGY_MODE = mkKernelOverride (option no);
            # https://github.com/damentz/liquorix-package/commit/fdc93f5633d22c26f0994fba751a26de0cb51a17
            WQ_POWER_EFFICIENT_DEFAULT = mkKernelOverride (option no);

            # Fix error: unused option: XXX.
            CFS_BANDWIDTH = mkKernelOverride (option no);
            PSI = mkKernelOverride (option no);
            RT_GROUP_SCHED = mkKernelOverride (option no);
            SCHED_AUTOGROUP = mkKernelOverride (option no);
            SCHED_CLASS_EXT = mkKernelOverride (option no);
            SCHED_CORE = mkKernelOverride (option no);
            UCLAMP_TASK = mkKernelOverride (option no);
            UCLAMP_TASK_GROUP = mkKernelOverride (option no);
          };

        extraPassthru.updateScript = [
          ./update-zen.py
          (if isLqx then "lqx" else "zen")
        ];

        extraMeta = {
          branch = lib.versions.majorMinor version + "/master";
          maintainers = with lib.maintainers; [
            thiagokokada
            jerrysm64
            axertheaxe
          ];
          teams = [ ];
          description =
            "Built using the best configuration and kernel sources for desktop, multimedia, and gaming workloads."
            + lib.optionalString isLqx " (Same as linux_zen, but less aggressive release schedule and additional extra config)";
          broken = stdenv.hostPlatform.isAarch64;
        };

      }
      // (args.argsOverride or { })
    );
in
zenKernelsFor variants.${variant}
