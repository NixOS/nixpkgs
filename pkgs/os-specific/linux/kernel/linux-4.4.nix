{ buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.260";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1vl8zhlkhqbw2xqvkqhw1z75mrzk5lsdcj8bd2k2fw7cbwa00ln6";
  };
} // (args.argsOverride or {}))
