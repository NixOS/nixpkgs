{ lib, buildPackages, fetchurl, perl, buildLinux, nixosTests, ... } @ args:

with lib;

buildLinux (args // rec {
  version = "5.15.113";

  # modDirVersion needs to be x.y.z, will automatically add .0 if needed
  modDirVersion = versions.pad 3 version;

  # branchVersion needs to be x.y
  extraMeta.branch = versions.majorMinor version;

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v5.x/linux-${version}.tar.xz";
    sha256 = "1jmrnd0ri75gl0k80g93zqyg00lbf1gqai3dga383ms92799hkja";
  };
} // (args.argsOverride or { }))
