{ buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.255";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "066101fzq5lr1pznw1hwlvsdgqpv8n7b2yi09qpv3xi0r41jvpxg";
  };
} // (args.argsOverride or {}))
