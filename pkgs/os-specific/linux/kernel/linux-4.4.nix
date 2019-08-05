{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.187";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1dlzb5yzcsicd41myj3q4dq2ql8xcc49brs5f7xjmc5ynvvjjgnc";
  };
} // (args.argsOverride or {}))
