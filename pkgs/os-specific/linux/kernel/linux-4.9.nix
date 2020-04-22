{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.219";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0i5wlyp11ss9p035bhq73xjx8iyk5dk4ynvd7msw5qfkrs6265vb";
  };
} // (args.argsOverride or {}))
