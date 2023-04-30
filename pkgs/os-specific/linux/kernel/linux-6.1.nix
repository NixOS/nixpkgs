{ lib, buildPackages, fetchurl, perl, buildLinux, nixosTests, ... } @ args:

with lib;

buildLinux (args // rec {
  version = "6.1.26";

  # modDirVersion needs to be x.y.z, will automatically add .0 if needed
  modDirVersion = versions.pad 3 version;

  # branchVersion needs to be x.y
  extraMeta.branch = versions.majorMinor version;

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v6.x/linux-${version}.tar.xz";
    sha256 = "0461ckgh9qm1pj9xyi61cvawqpavn2sb44wjx5g4mmkrm11w3p6z";
  };
  # TODO: possible to remove after any rebuild, e.g. after update.
  extraConfig = lib.optionalString (buildPackages.stdenv.system == "x86_64-linux") "\n";
} // (args.argsOverride or { }))
