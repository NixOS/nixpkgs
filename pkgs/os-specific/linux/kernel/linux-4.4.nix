{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.125";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0rrq9hwpsz0xjl10rf2c3brlkxq074cq3cr1gqp98na6zazl9xrx";
  };
} // (args.argsOverride or {}))
