{ lib, buildPackages, fetchurl, perl, buildLinux, nixosTests, ... } @ args:

buildLinux (args // rec {
  version = "6.0.19";

  # modDirVersion needs to be x.y.z, will automatically add .0 if needed
  modDirVersion = lib.versions.pad 3 version;

  # branchVersion needs to be x.y
  extraMeta.branch = lib.versions.majorMinor version;

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v6.x/linux-${version}.tar.xz";
    sha256 = "01q2sciv3l9brnsfcv9knx1ps3hq9rk1a08iqk3vscg3waq7xqxb";
  };
} // (args.argsOverride or { }))
