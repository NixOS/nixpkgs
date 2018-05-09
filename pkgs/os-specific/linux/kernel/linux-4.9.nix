{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.98";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1vqh33wdiqf3j4xfakxndhb8x6yr5ppwv9asx7kldjfvb8sr1k8j";
  };
} // (args.argsOverride or {}))
