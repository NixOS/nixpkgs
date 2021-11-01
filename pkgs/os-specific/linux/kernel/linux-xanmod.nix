{ lib, stdenv, buildLinux, fetchFromGitHub, ... } @ args:

let
  version = "5.14.15";
  release = "1";
  suffix = "xanmod${release}-cacule";
in
buildLinux (args // rec {
  inherit version;
  modDirVersion = "${version}-${suffix}";

  src = fetchFromGitHub {
    owner = "xanmod";
    repo = "linux";
    rev = modDirVersion;
    sha256 = "sha256-Z0A2D2t9rDUav4VpG3XdI13LConfWWs7PtsVfLyEQI8=";
  };

  structuredExtraConfig = with lib.kernel; {
    # Preemptive Full Tickless Kernel at 500Hz
    PREEMPT_VOLUNTARY = lib.mkForce no;
    PREEMPT = lib.mkForce yes;
    NO_HZ_FULL = yes;
    HZ_500 = yes;

    # Google's Multigenerational LRU Framework
    LRU_GEN = yes;
    LRU_GEN_ENABLED = yes;

    # Google's BBRv2 TCP congestion Control
    TCP_CONG_BBR2 = yes;
    DEFAULT_BBR2 = yes;

    # FQ-PIE Packet Scheduling
    NET_SCH_DEFAULT = yes;
    DEFAULT_FQ_PIE = yes;

    # Graysky's additional CPU optimizations
    CC_OPTIMIZE_FOR_PERFORMANCE_O3 = yes;

    # Android Ashmem and Binder IPC Driver as module for Anbox
    ASHMEM = module;
    ANDROID = yes;
    ANDROID_BINDER_IPC = module;
    ANDROID_BINDERFS = module;
    ANDROID_BINDER_DEVICES = freeform "binder,hwbinder,vndbinder";

    # Futex WAIT_MULTIPLE implementation for Wine / Proton Fsync.
    # Futex2 interface compatible w/ latest Wine / Proton Fsync.
    FUTEX = yes;
    FUTEX2 = yes;
    FUTEX_PI = yes;
  };

  extraMeta = {
    branch = "5.14-cacule";
    maintainers = with lib.maintainers; [ fortuneteller2k lovesegfault ];
    description = "Built with custom settings and new features built to provide a stable, responsive and smooth desktop experience";
    broken = stdenv.isAarch64;
  };
} // (args.argsOverride or { }))
