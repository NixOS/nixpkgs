{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.267";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0q0a49b3wsxk9mqyy8b55lr1gmiqxjpqh2nlhj4xwcfzd7z9lfwq";
  };
} // (args.argsOverride or {}))
