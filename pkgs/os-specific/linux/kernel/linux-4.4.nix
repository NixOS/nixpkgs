{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.176";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0pf7y4dcnf4mn11wgjd65v09kx3p712ky50w6vrn45v9m80m9ni7";
  };
} // (args.argsOverride or {}))
