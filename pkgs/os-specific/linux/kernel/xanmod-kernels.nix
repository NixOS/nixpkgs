{ lib, stdenv, fetchFromGitHub, buildLinux, ... } @ args:

let
  # These names are how they are designated in https://xanmod.org.

  # NOTE: When updating these, please also take a look at the changes done to
  # kernel config in the xanmod version commit
  ltsVariant = {
    version = "6.1.58";
    hash = "sha256-Lnp1CSh1jLbIkEx9hLfxhdIA12iQZmywhOec9uZ7UjI=";
    variant = "lts";
  };

  mainVariant = {
    version = "6.5.8";
    hash = "sha256-lHi+O7RE6YdiqPmuxHajGkc7jS9F5cB89+JbTVKkB/c=";
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
      # Google's BBRv3 TCP congestion Control
      TCP_CONG_BBR = yes;
      DEFAULT_BBR = yes;

      # WineSync driver for fast kernel-backed Wine
      WINESYNC = module;

      # Preemptive Full Tickless Kernel at 500Hz
      HZ = freeform "500";
      HZ_500 = yes;
      HZ_1000 = no;
    };

    extraMeta = {
      branch = lib.versions.majorMinor version;
      maintainers = with lib.maintainers; [ fortuneteller2k lovesegfault atemu shawn8901 zzzsy ];
      description = "Built with custom settings and new features built to provide a stable, responsive and smooth desktop experience";
      broken = stdenv.isAarch64;
    };
  } // (args.argsOverride or { }));
in
{
  lts = xanmodKernelFor ltsVariant;
  main = xanmodKernelFor mainVariant;
}
