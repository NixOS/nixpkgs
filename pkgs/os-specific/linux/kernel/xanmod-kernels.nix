{ lib, stdenv, fetchFromGitHub, buildLinux, ... } @ args:

let
  # These names are how they are designated in https://xanmod.org.

  # NOTE: When updating these, please also take a look at the changes done to
  # kernel config in the xanmod version commit
  ltsVariant = {
    version = "6.6.28";
    hash = "sha256-0ld4pZIddfkGytxzqgC7AGD3gc2H9mhZbhpbFLD3G+s=";
    variant = "lts";
  };

  mainVariant = {
    version = "6.8.7";
    hash = "sha256-S9UooZhMtvfyL2BVUfMBxvPLkZvXm37duWSjcpk5dvY=";
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
      # CPUFreq governor Performance
      CPU_FREQ_DEFAULT_GOV_PERFORMANCE = lib.mkOverride 60 yes;
      CPU_FREQ_DEFAULT_GOV_SCHEDUTIL = lib.mkOverride 60 no;

      # Full preemption
      PREEMPT = lib.mkOverride 60 yes;
      PREEMPT_VOLUNTARY = lib.mkOverride 60 no;

      # Google's BBRv3 TCP congestion Control
      TCP_CONG_BBR = yes;
      DEFAULT_BBR = yes;

      # Preemptive Full Tickless Kernel at 250Hz
      HZ = freeform "250";
      HZ_250 = yes;
      HZ_1000 = no;
    };

    extraMeta = {
      branch = lib.versions.majorMinor version;
      maintainers = with lib.maintainers; [ moni lovesegfault atemu shawn8901 zzzsy ];
      description = "Built with custom settings and new features built to provide a stable, responsive and smooth desktop experience";
      broken = stdenv.isAarch64;
    };
  } // (args.argsOverride or { }));
in
{
  lts = xanmodKernelFor ltsVariant;
  main = xanmodKernelFor mainVariant;
}
