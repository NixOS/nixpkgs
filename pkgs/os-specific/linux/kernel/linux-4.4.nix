{ stdenv, buildPackages, fetchurl, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.4.209";
  extraMeta.branch = "4.4";

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "0m94795grq3sbj7jlmwc0ncq3vap9lf1z00sdiys17kjs3bcfbnh";
  };
} // (args.argsOverride or {}))
