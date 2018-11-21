{ stdenv, buildPackages, hostPlatform, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.164";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "041w65dxsdcdpf7isis2r4xabfm9pbhfgxxx7n9d1nv7grss3d4v";
  };
} // (args.argsOverride or {}))
