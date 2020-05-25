{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.224";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0jf92cx0b3wq9fxa3169wk4wqvy58hglfk6lsynszy8kjplhfvfz";
  };
} // (args.argsOverride or {}))
