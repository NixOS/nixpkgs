{ buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.257";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0njb4gf77vix2xgnyhmrzf67czpqfng9np644l9j18dn4mb7q1iy";
  };
} // (args.argsOverride or {}))
