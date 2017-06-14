{ stdenv, fetchgit, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.11-git";
  modDirVersion = "4.11.0";
  extraMeta.branch = "master";
  extraMeta.maintainers = [ stdenv.lib.maintainers.davidak ];

  src = fetchgit {
    url = "https://evilpiepirate.org/git/bcachefs.git";
    rev = "87a9a6efd0ab602fc8d429fe75c427f1ac278f41";
    sha256 = "0h73r7ypqcwcsfzkxdwcvli96cig3gmnyhfw251fv2bsyq26ik9f";
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

