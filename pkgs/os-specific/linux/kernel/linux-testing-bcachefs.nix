{ stdenv, fetchgit, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.11-git";
  modDirVersion = "4.11.0";
  extraMeta.branch = "master";
  extraMeta.maintainers = [ stdenv.lib.maintainers.davidak ];

  src = fetchgit {
    url = "https://evilpiepirate.org/git/bcachefs.git";
    rev = "43e3159567958ea70c8a95d98fdb6e881153a656";
    sha256 = "1595l2wabf74q8fb7fk14mz5iv7x7wk9nhjddyd9v3v5nw9krm4v";
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

