{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.127";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "03yxdzmlikyvbkfaha871h9n7y58lyzyxgybsx09ln4pxnnswxwl";
  };
} // (args.argsOverride or {}))
