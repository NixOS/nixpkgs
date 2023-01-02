{ lib, buildPackages, fetchurl, perl, buildLinux, nixosTests, ... } @ args:

with lib;

buildLinux (args // rec {
  version = "5.15.85";

  # modDirVersion needs to be x.y.z, will automatically add .0 if needed
  modDirVersion = versions.pad 3 version;

  # branchVersion needs to be x.y
  extraMeta.branch = versions.majorMinor version;

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v5.x/linux-${version}.tar.xz";
    sha256 = "024qhjh9mgfnanr1qd8002n6a4wpn98lajli12a0m3n9z8lsw2rc";
  };
} // (args.argsOverride or { }))
