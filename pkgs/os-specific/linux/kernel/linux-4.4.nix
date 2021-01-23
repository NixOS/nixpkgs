{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.252";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0lchvfvn0kvqh1yixwscz4wrzd965zsxjkpc7nqiw9rhmvma3paf";
  };
} // (args.argsOverride or {}))
