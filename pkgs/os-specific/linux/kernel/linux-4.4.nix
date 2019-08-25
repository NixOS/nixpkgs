{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.190";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1rf28cjrrmj7mm8xqlfld6k20ddk15j4mmyarqibjx9pk9acij7y";
  };
} // (args.argsOverride or {}))
