{ lib, stdenv, buildLinux, fetchFromGitHub, realtime ? false, ... } @ args:

let
  version = if !realtime then "5.13.12" else "5.13.1";
  release = "1";
  suffix = if !realtime then "xanmod${release}-cacule" else "rt${release}-xanmod${release}";
in
buildLinux (args // rec {
  inherit version;
  modDirVersion = "${version}-${suffix}";

  src = fetchFromGitHub {
    owner = "xanmod";
    repo = "linux";
    rev = modDirVersion;
    sha256 =
      if !realtime
      then "sha256-cuZ8o0Ogi2dg4kVoFv4aqThRPDVI271i+DVw5Z4R7Kg="
      else "sha256-VSeeGe9D4/nX3cs7mvv70v1I0PN2QHMpaVgR5XuuqKY=";
  };

  structuredExtraConfig = with lib.kernel; {
    # Preemptive Full Tickless Kernel at 500Hz
    EXPERT = if realtime then yes else no;
    PREEMPT_VOLUNTARY = lib.mkForce no;
    PREEMPT = if !realtime then (lib.mkForce yes) else no;
    PREEMPT_RT = if realtime then yes else no;
    NO_HZ_FULL = yes;
    HZ_500 = yes;
    RT_GROUP_SCHED = lib.mkForce (option no);

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
    branch = if !realtime then "5.13-cacule" else "5.13-rt";
    maintainers = with lib.maintainers; [ fortuneteller2k ] ++ lib.optional (!realtime) lovesegfault;
    description = "Built with custom settings and new features built to provide a stable, responsive and smooth desktop experience"
      + lib.strings.optionalString realtime " (realtime version)";
    broken = stdenv.isAarch64;
  };
} // (args.argsOverride or { }))
