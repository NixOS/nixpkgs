{ buildPackages, fetchFromGitHub, perl, buildLinux, libelf, util-linux, ... } @ args:

buildLinux (args // rec {
  version = "4.14.180-176";

  # modDirVersion needs to be x.y.z.
  modDirVersion = "4.14.180";

  # branchVersion needs to be x.y.
  extraMeta.branch = "4.14";

  src = fetchFromGitHub {
    owner = "hardkernel";
    repo = "linux";
    rev = version;
    sha256 = "0n7i7a2bkrm9p1wfr20h54cqm32fbjvwyn703r6zm1f6ivqhk43v";
  };

  defconfig = "odroidxu4_defconfig";

  # This extraConfig is (only) required because the gator module fails to build as-is.
  extraConfig = ''

    GATOR n

    # This attempted fix applies correctly but does not fix the build.
    #GATOR_MALI_MIDGARD_PATH ${src}/drivers/gpu/arm/midgard

  '' + (args.extraConfig or "");

  extraMeta.platforms = [ "armv7l-linux" ];

} // (args.argsOverride or {}))
