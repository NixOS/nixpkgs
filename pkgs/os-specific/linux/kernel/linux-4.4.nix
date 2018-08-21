{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.150";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1xdfq11pa4ayi89vynbddq5k47f01szc04lbl5aaxpnch982jj8g";
  };
} // (args.argsOverride or {}))
