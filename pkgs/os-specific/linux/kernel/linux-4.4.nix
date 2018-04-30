{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.130";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1rad8fa25hzifpxqxsc7wzhcssbbv32rc03nvljygvlxcn8dz6xj";
  };
} // (args.argsOverride or {}))
