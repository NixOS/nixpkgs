{ buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.254";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "11wca1mprlcyk7r5h1c8rx3hr7l6mj4i85jaaf106s7wqcm8wamd";
  };
} // (args.argsOverride or {}))
