{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.201";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "125xmh5h1zmfniidpjljny53qkl4phpxaali69i66lajscxx8grq";
  };
} // (args.argsOverride or {}))
