{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.196";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1vy6j9ycl5aw0dmj4n9kih5i8igybk0ilahlwbn30mlp9aq15az0";
  };
} // (args.argsOverride or {}))
