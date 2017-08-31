{ stdenv, hostPlatform, fetchgit, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.11.2017.08.23";
  modDirVersion = "4.11.0";
  extraMeta.branch = "master";
  extraMeta.maintainers = [ stdenv.lib.maintainers.davidak ];

  src = fetchgit {
    url = "https://evilpiepirate.org/git/bcachefs.git";
    rev = "fb8082a13d49397346a04ce4d3904569b0287738";
    sha256 = "18csg2zb4lnhid27h5w95j3g8np29m8y3zfpfgjl1jr2jks64kid";
  };

  extraConfig = ''
    BCACHEFS_FS m
  '';

  features.iwlwifi = true;
  features.efiBootStub = true;
  features.needsCifsUtils = true;
  features.netfilterRPFilter = true;

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))

