{ lib, buildPackages, fetchurl, perl, buildLinux, nixosTests, ... } @ args:

with lib;

buildLinux (args // rec {
  version = "6.1.32";

  # modDirVersion needs to be x.y.z, will automatically add .0 if needed
  modDirVersion = versions.pad 3 version;

  # branchVersion needs to be x.y
  extraMeta.branch = versions.majorMinor version;

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v6.x/linux-${version}.tar.xz";
    sha256 = "0v0saai735jzaj3dbpgp6sbdi95n3lmv78pbg1xy9fd2kfhbg23w";
  };
} // (args.argsOverride or { }))
