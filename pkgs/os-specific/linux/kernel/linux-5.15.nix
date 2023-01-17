{ lib, buildPackages, fetchurl, perl, buildLinux, nixosTests, ... } @ args:

buildLinux (args // rec {
  version = "5.15.88";

  # modDirVersion needs to be x.y.z, will automatically add .0 if needed
  modDirVersion = lib.versions.pad 3 version;

  # branchVersion needs to be x.y
  extraMeta.branch = lib.versions.majorMinor version;

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v5.x/linux-${version}.tar.xz";
    sha256 = "10d1h5d962r9c0xmcw1rylibjz4n2g552axdz5zgjfkav7ykjxa1";
  };
} // (args.argsOverride or { }))
