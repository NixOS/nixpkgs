{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.172";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1yrrwvj260sqnn8qh7a2b31d31jjnap6qh2f6jhdy275q6rickgv";
  };
} // (args.argsOverride or {}))
