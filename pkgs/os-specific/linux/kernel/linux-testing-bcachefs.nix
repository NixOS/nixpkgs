{ stdenv, buildPackages, hostPlatform, fetchgit, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.15.2018.02.09";
  modDirVersion = "4.15.0";
  extraMeta.branch = "master";
  extraMeta.maintainers = [ stdenv.lib.maintainers.davidak ];

  src = fetchgit {
    url = "https://evilpiepirate.org/git/bcachefs.git";
    rev = "4506cd5ead31209a6a646c2412cbc7be735ebda4";
    sha256 = "0fcyf3y27k2lga5na4dhdyc47br840gkqynv8gix297pqxgidrib";
  };

  extraConfig = ''
    BCACHEFS_FS m
  '';

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
