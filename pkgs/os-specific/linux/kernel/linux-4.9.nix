{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.241";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0b5k9cwz7vpaybw4nd03pn2z4d8qbhmhd9mx4j2yd0fqj57x1in4";
  };
} // (args.argsOverride or {}))
