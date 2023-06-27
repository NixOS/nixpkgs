{ lib, fetchurl, buildLinux, ... } @ args:

with lib;

buildLinux (args // rec {
  version = "6.4";

  # modDirVersion needs to be x.y.z, will automatically add .0 if needed
  modDirVersion = versions.pad 3 version;

  # branchVersion needs to be x.y
  extraMeta.branch = versions.majorMinor version;

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v6.x/linux-${version}.tar.xz";
    sha256 = "sha256-j6BYjwws7KRMrHeg45ukjJ8AprncaXYcAqXT76yNp/M=";
  };
} // (args.argsOverride or { }))
