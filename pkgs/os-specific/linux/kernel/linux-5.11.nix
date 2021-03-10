{ lib, buildPackages, fetchurl, perl, buildLinux, modDirVersionArg ? null, ... } @ args:

with lib;

buildLinux (args // rec {
  version = "5.11.5";

  # modDirVersion needs to be x.y.z, will automatically add .0 if needed
  modDirVersion = if (modDirVersionArg == null) then concatStringsSep "." (take 3 (splitVersion "${version}.0")) else modDirVersionArg;

  # branchVersion needs to be x.y
  extraMeta.branch = versions.majorMinor version;

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v5.x/linux-${version}.tar.xz";
    sha256 = "0srxpl44px1fr7y6nl8pq61vmbkkdbsmxy5k7wvqka33gdhy8212";
  };
} // (args.argsOverride or {}))
