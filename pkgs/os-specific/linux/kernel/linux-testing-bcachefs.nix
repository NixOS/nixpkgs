{ stdenv, buildPackages, hostPlatform, fetchgit, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.15.2018.04.14";
  modDirVersion = "4.15.0";
  extraMeta.branch = "master";
  extraMeta.maintainers = [ stdenv.lib.maintainers.davidak stdenv.lib.maintainers.chiiruno ];

  src = fetchgit {
    url = "https://evilpiepirate.org/git/bcachefs.git";
    rev = "3b7c824e9330a640312fce1b04537c684c1d602c";
    sha256 = "1l5ib28qkhrxggn6zj9b2839543anbxk2ip75yizgzlv9vr5m4pk";
  };

  extraConfig = ''
    BCACHEFS_FS m
  '';

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
