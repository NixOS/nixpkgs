{ lib, stdenv, fetchFromGitHub, buildLinux, ... } @ args:

let
  # These names are how they are designated in https://xanmod.org.
  ltsVariant = {
    version = "5.15.84";
    hash = "sha256-CN3GOuwSicJ6Oa9BiKTyZg7fpzWc846v2SV9JRiOu3M=";
    variant = "lts";
  };

  mainVariant = {
    version = "6.1.3";
    hash = "sha256-YtkmbbFEfvww7yJ4MpLQ3M6QjbBXSU9Pjwu0Dq/dIcs=";
    variant = "main";
  };

  xanmodKernelFor = { version, suffix ? "xanmod1", hash, variant }: buildLinux (args // rec {
    inherit version;
    modDirVersion = lib.versions.pad 3 "${version}-${suffix}";

    src = fetchFromGitHub {
      owner = "xanmod";
      repo = "linux";
      rev = modDirVersion;
      inherit hash;
    };

    structuredExtraConfig = with lib.kernel; {
      # AMD P-state driver
      X86_AMD_PSTATE = lib.mkOverride 60 yes;

      # Google's BBRv2 TCP congestion Control
      TCP_CONG_BBR2 = yes;
      DEFAULT_BBR2 = yes;

      # Multigenerational LRU framework
      # This can be removed when the LTS variant reaches version >= 6.1 (since it's on by default then)
      LRU_GEN = yes;
      LRU_GEN_ENABLED = yes;

      # FQ-PIE Packet Scheduling
      NET_SCH_DEFAULT = yes;
      DEFAULT_FQ_PIE = yes;

      # Futex WAIT_MULTIPLE implementation for Wine / Proton Fsync.
      FUTEX = yes;
      FUTEX_PI = yes;

      # WineSync driver for fast kernel-backed Wine
      WINESYNC = module;

      # Preemptive Full Tickless Kernel at 500Hz
      HZ = freeform "500";
      HZ_500 = yes;
      HZ_1000 = no;
    };

    extraMeta = {
      branch = lib.versions.majorMinor version;
      maintainers = with lib.maintainers; [ fortuneteller2k lovesegfault atemu ];
      description = "Built with custom settings and new features built to provide a stable, responsive and smooth desktop experience";
      broken = stdenv.isAarch64;
    };
  } // (args.argsOverride or { }));
in
{
  lts = xanmodKernelFor ltsVariant;
  main = xanmodKernelFor mainVariant;
}
