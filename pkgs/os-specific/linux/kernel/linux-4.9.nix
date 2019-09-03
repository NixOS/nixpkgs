{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.190";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "05ha3snfk0vdqk9i27icwpq2if0h2jvshavn69ldwqm4h2h1r2py";
  };
} // (args.argsOverride or {}))
