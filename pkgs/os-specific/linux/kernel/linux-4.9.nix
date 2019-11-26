{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.203";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0jd8n8y3yf59sgfjhgjxsznxng7s4b30x5vdb48wrpgqmz7m1n8w";
  };
} // (args.argsOverride or {}))
