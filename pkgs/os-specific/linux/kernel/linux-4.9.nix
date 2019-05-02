{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.172";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "03mlbqaj4jz4s72a034i1z8h5swdk04brdzllrlv1h4wk0q8whj9";
  };
} // (args.argsOverride or {}))
