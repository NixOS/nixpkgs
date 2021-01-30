{ stdenv, buildPackages, fetchurl, perl, buildLinux, modDirVersionArg ? null, lib, date, version, sha256, ... } @ args:

with stdenv.lib;

buildLinux (args // rec {
  inherit version;

  modDirVersion = if modDirVersionArg == null
    then lib.strings.concatStringsSep "-" [ version date ]
    else modDirVersionArg;

  src = fetchurl {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/snapshot/linux-next-next-${date}.tar.gz";
    inherit sha256;
  };

} // (args.argsOverride or {}))
