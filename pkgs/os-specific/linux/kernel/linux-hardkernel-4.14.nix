{ stdenv, buildPackages, hostPlatform, fetchFromGitHub, perl, buildLinux, libelf, utillinux, ... } @ args:

buildLinux (args // rec {
  version = "4.14.55-146";

  # modDirVersion needs to be x.y.z.
  modDirVersion = "4.14.55";

  # branchVersion needs to be x.y.
  extraMeta.branch = "4.14";

  src = fetchFromGitHub {
    owner = "hardkernel";
    repo = "linux";
    rev = version;
    sha256 = "1bm1njng4rwfylgnqv06vabkvybm9rikqj1lsb7p9qcs3y1kw6mh";
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
