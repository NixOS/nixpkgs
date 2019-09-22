{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.194";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1qy20vw5bhnsfbh95sdhjbk6y94js8m4ryd3m7xg2qg4hisvpx6m";
  };
} // (args.argsOverride or {}))
