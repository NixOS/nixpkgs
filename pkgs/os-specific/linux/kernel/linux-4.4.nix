{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.122";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1hxph2bn2wdamk1p5sxl2szgsk4aybb0245x1rvf85a6skhjqc7g";
  };
} // (args.argsOverride or {}))
