{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.116";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "07gzjfv24jrn76aga7c8f1y5xsz5if6xbdli1cpfzg60ps8q57lr";
  };
} // (args.argsOverride or {}))
