{ lib, buildPackages, fetchurl, perl, buildLinux, nixosTests, ... } @ args:

with lib;

buildLinux (args // rec {
  version = "6.1.1";

  # modDirVersion needs to be x.y.z, will automatically add .0 if needed
  modDirVersion = versions.pad 3 version;

  # branchVersion needs to be x.y
  extraMeta.branch = versions.majorMinor version;

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v6.x/linux-${version}.tar.xz";
    sha256 = "1yqxjz0f722s2bcssqg5b6m6lvq5l4vrlh3bjviajda4rxvi7rm3";
  };
} // (args.argsOverride or { }))
