{ buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.262";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1zq77x9zf1wbk8n17rnblm5lfwlkin1xnxb3sxirwb9njm07cbmj";
  };
} // (args.argsOverride or {}))
