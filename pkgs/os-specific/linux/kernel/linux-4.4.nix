{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.206";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "14ylg9cm7z12mvkzg8z92gsw0libw9xz392ayzw0d9cgw1py39ax";
  };
} // (args.argsOverride or {}))
