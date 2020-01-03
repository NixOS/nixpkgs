{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.207";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "024flajnl3l4yk8sgqdrfrl21js4vsjcv4ivmjblj4l9fl3hdjb6";
  };
} // (args.argsOverride or {}))
