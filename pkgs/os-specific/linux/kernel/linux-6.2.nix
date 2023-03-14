{ lib, buildPackages, fetchurl, perl, buildLinux, nixosTests, ... } @ args:

with lib;

buildLinux (args // rec {
  version = "6.2.6";

  # modDirVersion needs to be x.y.z, will automatically add .0 if needed
  modDirVersion = versions.pad 3 version;

  # branchVersion needs to be x.y
  extraMeta.branch = versions.majorMinor version;

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v6.x/linux-${version}.tar.xz";
    sha256 = "179x1fqgi3drg1q1xy0648hvy7cpc79yzn2r248rq4mprvbz3qhz";
  };
} // (args.argsOverride or { }))
