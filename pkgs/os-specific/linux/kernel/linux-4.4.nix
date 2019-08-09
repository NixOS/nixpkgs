{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.188";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1llxamm62kgqd7dig98n8m16qas8dd8rrkmwpfcdgyf8rag216ff";
  };
} // (args.argsOverride or {}))
