{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.251";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "13mnlwwcwvbyqn8lafjymq66qjfj7nksdiyrcgymx8s03z1why86";
  };
} // (args.argsOverride or {}))
