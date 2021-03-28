{ buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.263";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1qqh3n09pn87n6f7ain3am8k7j043vzm65qcvccq9as129y5w1a2";
  };
} // (args.argsOverride or {}))
