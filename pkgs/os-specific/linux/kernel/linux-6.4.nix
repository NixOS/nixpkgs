{ lib, fetchurl, buildLinux, ... } @ args:

with lib;

buildLinux (args // rec {
  version = "6.4.7";

  # modDirVersion needs to be x.y.z, will automatically add .0 if needed
  modDirVersion = versions.pad 3 version;

  # branchVersion needs to be x.y
  extraMeta.branch = versions.majorMinor version;

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v6.x/linux-${version}.tar.xz";
    sha256 = "1n57qijg0m27wcrqll8rb1hi1n0n8ca3bzsnbz05d9ya3nv3q56y";
  };
} // (args.argsOverride or { }))
