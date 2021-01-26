{ buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.253";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0nlqnfhrkaj2s582kc0wxqi0881hgp6l9z85qx4ckflc8jwrh7k6";
  };
} // (args.argsOverride or {}))
