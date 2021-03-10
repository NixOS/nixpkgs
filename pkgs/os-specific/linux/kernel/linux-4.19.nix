{ lib, buildPackages, fetchurl, perl, buildLinux, modDirVersionArg ? null, ... } @ args:

with lib;

buildLinux (args // rec {
  version = "4.19.179";

  # modDirVersion needs to be x.y.z, will automatically add .0 if needed
  modDirVersion = if (modDirVersionArg == null) then concatStringsSep "." (take 3 (splitVersion "${version}.0")) else modDirVersionArg;

  # branchVersion needs to be x.y
  extraMeta.branch = versions.majorMinor version;

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "14iy4i6xm2mva359dyrx6s1djpw7rxvnkydcbm6lnfvn7sik37a9";
  };
} // (args.argsOverride or {}))
