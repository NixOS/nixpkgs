{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.88";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "094cxc86ajnsai1vwy76mmg7l3b9lvhk6mw6746lsr3fnzv1fkq7";
  };
} // (args.argsOverride or {}))
