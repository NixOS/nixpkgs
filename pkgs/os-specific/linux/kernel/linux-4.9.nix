{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.9.156";
  extraMeta.branch = "4.9";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "05m82x2zg0nkc6ayk6akgpfhz31zp6dhhlklcfmi419p8fxbkcay";
  };
} // (args.argsOverride or {}))
