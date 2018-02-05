{ stdenv, buildPackages, hostPlatform, fetchgit, perl, buildLinux, ... } @ args:

import ./generic.nix (args // rec {
  version = "4.15.2018.02.05";
  modDirVersion = "4.15.0";
  extraMeta.branch = "master";
  extraMeta.maintainers = [ stdenv.lib.maintainers.davidak ];

  src = fetchgit {
    url = "https://evilpiepirate.org/git/bcachefs.git";
    rev = "67109c13b64a806473f6fb126d3ea99c3a79592c";
    sha256 = "0dpacpnps3gzd4jwppm54gqgq6vw3mq2sgd78qmpg6rr2dw848mb";
  };

  extraConfig = ''
    BCACHEFS_FS m
  '';

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
