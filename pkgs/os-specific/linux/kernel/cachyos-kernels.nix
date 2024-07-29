{
  lib,
  fetchFromGitHub,
  pkgs,
  stdenv,
  buildLinux,
  ...
}@args:

let
  # When updating this package, make sure to account for important config changes in https://github.com/CachyOS/linux-cachyos/blob/master/linux-cachyos/config and https://github.com/CachyOS/linux-cachyos/blob/master/linux-cachyos-lts/config as well
  cachyPatches = fetchFromGitHub {
    owner = "CachyOS";
    repo = "kernel-patches";
    rev = "04fb9178158a7714aeb908c7a5310c4e0d6ea4b6";
    hash = "sha256-KTvZxYy+UgLNg1DYBMrJrRdxDo3N5ususlrHyRBS7C8=";
  };

  ltsVariant = {
    version = "6.6.43";
    variantDescription = "Linux EEVDF-BORE scheduler Kernel by CachyOS with other patches and improvements";
    source = {
      url = "mirror://kernel/linux/kernel/v6.x/linux-6.6.43.tar.xz";
      hash = "sha256-Ctg7Ghp4ChqtlI1VqlXuY8UMYm8tRpELnSGAAo0QCl4=";
    };
    patches = [
      {
        name = "cachyos-base-all";
        patch = "${cachyPatches}/6.6/all/0001-cachyos-base-all.patch";
      }
      {
        name = "bore-cachy";
        patch = "${cachyPatches}/6.6/sched/0001-bore-cachy.patch";
      }
    ];

    config = with lib.kernel; {
      # CachyOS config
      CACHY = yes;

      # CPU Scheduler
      SCHED_BORE = yes;

      # LLVM level
      LTO_NONE = yes;

      # Tick rate
      HZ_300 = unset;
      HZ_1000 = yes;
      HZ = freeform "1000";

      NR_CPUS = lib.mkOverride 60 (freeform "320");

      # Tick type
      HZ_PERIODIC = unset;
      NO_HZ_IDLE = unset;
      CONTEXT_TRACKING_FORCE = unset;
      NO_HZ_FULL = yes;
      NO_HZ = yes;
      NO_HZ_COMMON = yes;
      CONTEXT_TRACKING = yes;

      # Preempt type
      PREEMPT_BUILD = yes;
      PREEMPT_NONE = unset;
      PREEMPT_VOLUNTARY = lib.mkOverride 60 unset;
      PREEMPT = lib.mkOverride 60 yes;
      PREEMPT_COUNT = yes;
      PREEMPTION = yes;
      PREEMPT_DYNAMIC = yes;

      # Enable O3
      CC_OPTIMIZE_FOR_PERFORMANCE = unset;
      CC_OPTIMIZE_FOR_PERFORMANCE_O3 = yes;

      # Enable bbr3
      DEFAULT_CUBIC = unset;
      TCP_CONG_BBR = yes;
      DEFAULT_BBR = yes;
      DEFAULT_TCP_CONG = freeform "bbr";

      # LRU config
      LRU_GEN = yes;
      LRU_GEN_ENABLED = yes;
      LRU_GEN_STATS = unset;

      # VMA config
      PER_VMA_LOCK = yes;
      PER_VMA_LOCK_STATS = unset;

      # THP
      TRANSPARENT_HUGEPAGE_MADVISE = lib.mkOverride 60 unset;
      TRANSPARENT_HUGEPAGE_ALWAYS = lib.mkOverride 60 yes;

      USER_NS = yes;

      # Modules
      ## Apple T2 https://github.com/t2linux/linux-t2-patches/blob/main/extra_config
      APPLE_GMUX = module;
      BRCMFMAC = module;
      BT_BCM = module;
      BT_HCIBCM4377 = module;
      BT_HCIUART_BCM = yes;
      BT_HCIUART = module;
      HID_APPLE = module;
      HID_SENSOR_ALS = module;
      SENSORS_APPLESMC = module;
      SND_PCM = module;
      STAGING = yes;

      I2C_NCT6775 = module;
      LEDS_TRIGGER_BLKDEV = module;
      STEAMDECK = module;
    };
  };

  # If updating this, remember to raise the version constraints in:
  # * pkgs/os-specific/linux/mbp-modules/mbp2018-bridge-drv/default.nix
  # * pkgs/os-specific/linux/v4l2loopback/default.nix
  mainVariant = {
    version = "6.10.2";
    variantDescription = "Linux SCHED-EXT + BORE + Cachy Sauce Kernel by CachyOS with other patches and improvements";
    source = {
      url = "mirror://kernel/linux/kernel/v6.x/linux-6.10.2.tar.xz";
      hash = "sha256-c9hSDdnLpaz8XnII52s12XQLiq44IQqSJOMuxMDSm3A=";
    };
    patches = [
      {
        name = "cachyos-base-all";
        patch = "${cachyPatches}/6.10/all/0001-cachyos-base-all.patch";
      }
      {
        name = "sched-ext";
        patch = "${cachyPatches}/6.10/sched/0001-sched-ext.patch";
      }
      {
        name = "bore-cachy-ext";
        patch = "${cachyPatches}/6.10/sched/0001-bore-cachy-ext.patch";
      }
    ];

    config = with lib.kernel; {
      # CachyOS config
      CACHY = yes;

      # CPU Scheduler
      SCHED_CLASS_EXT = yes;
      SCHED_BORE = yes;
      MIN_BASE_SLICE_NS = freeform "1000000";

      # LLVM level
      LTO_NONE = yes;

      # Tick rate
      HZ_300 = unset;
      HZ_1000 = yes;
      HZ = freeform "1000";

      NR_CPUS = lib.mkOverride 60 (freeform "320");

      # Tick type
      HZ_PERIODIC = unset;
      NO_HZ_IDLE = unset;
      CONTEXT_TRACKING_FORCE = unset;
      NO_HZ_FULL = yes;
      NO_HZ = yes;
      NO_HZ_COMMON = yes;
      CONTEXT_TRACKING = yes;

      # Preempt type
      PREEMPT_BUILD = yes;
      PREEMPT_NONE = unset;
      PREEMPT_VOLUNTARY = lib.mkOverride 60 unset;
      PREEMPT = lib.mkOverride 60 yes;
      PREEMPT_COUNT = yes;
      PREEMPTION = yes;
      PREEMPT_DYNAMIC = yes;

      # Enable O3
      CC_OPTIMIZE_FOR_PERFORMANCE = unset;
      CC_OPTIMIZE_FOR_PERFORMANCE_O3 = yes;

      # Enable bbr3
      TCP_CONG_CUBIC = lib.mkOverride 60 module;
      DEFAULT_CUBIC = unset;
      TCP_CONG_BBR = yes;
      DEFAULT_BBR = yes;
      DEFAULT_TCP_CONG = freeform "bbr";

      # Select THP
      TRANSPARENT_HUGEPAGE_MADVISE = lib.mkOverride 60 unset;
      TRANSPARENT_HUGEPAGE_ALWAYS = lib.mkOverride 60 yes;

      USER_NS = yes;

      # Modules
      ## Apple T2 https://github.com/t2linux/linux-t2-patches/blob/main/extra_config
      APPLE_BCE = module;
      APPLE_GMUX = module;
      BRCMFMAC = module;
      BT_BCM = module;
      BT_HCIBCM4377 = module;
      BT_HCIUART_BCM = yes;
      BT_HCIUART = module;
      HID_APPLETB_BL = module;
      HID_APPLETB_KBD = module;
      HID_APPLE = module;
      DRM_APPLETBDRM = module;
      HID_SENSOR_ALS = module;
      SENSORS_APPLESMC = module;
      SND_PCM = module;
      STAGING = yes;

      I2C_NCT6775 = module;
      NTSYNC = module;
      V4L2_LOOPBACK = module;
    };
  };

  cachyosKernelFor =
    {
      version,
      variantDescription,
      source,
      patches,
      config,
    }:
    buildLinux (
      args
      // rec {
        inherit version;
        pname = "linux-cachyos";
        modDirVersion = version;
        isCachy = true;

        src = pkgs.fetchurl {
          url = source.url;
          hash = source.hash;
        };

        kernelPatches = patches;

        structuredExtraConfig = config;

        extraMeta = {
          branch = lib.versions.majorMinor version;
          maintainers = with lib.maintainers; [ drakon64 ];
          description = variantDescription;
          broken = stdenv.isAarch64;
        };
      }
      // (args.argsOverride or { })
    );
in
{
  lts = cachyosKernelFor ltsVariant;
  main = cachyosKernelFor mainVariant;
}
