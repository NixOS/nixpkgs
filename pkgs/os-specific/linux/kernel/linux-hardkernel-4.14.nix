{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, libelf, utillinux, ... } @ args:

buildLinux (args // rec {
  version = "4.14.47-139";

  # modDirVersion needs to be x.y.z.
  modDirVersion = "4.14.47";

  # branchVersion needs to be x.y. 
  extraMeta.branch = "4.14";

  src = fetchurl {
    url = "https://github.com/hardkernel/linux/archive/${version}.tar.gz";
    sha256 = "1n43a3rhpjq851qrn17r1dkibv6sqlmwxvl3hras4qr391x61y6n";
  };

} // (args.argsOverride or {}))
