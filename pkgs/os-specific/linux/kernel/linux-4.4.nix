{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.247";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1jh7vmyx55krk6y2r9v48liifs5wwkgns3gp8rs5sm4klfm36r2a";
  };
} // (args.argsOverride or {}))
