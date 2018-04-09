{ stdenv, buildPackages, hostPlatform, fetchgit, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.15.2018.03.22";
  modDirVersion = "4.15.0";
  extraMeta.branch = "master";
  extraMeta.maintainers = [ stdenv.lib.maintainers.davidak stdenv.lib.maintainers.chiiruno ];

  src = fetchgit {
    url = "https://evilpiepirate.org/git/bcachefs.git";
    rev = "919a34d47a68f3e5f00a7ce5efb67748ec31bd62";
    sha256 = "1j17my3046ry8zdcvf8h2vnij89wkwmv64w3g2pf9lksh2909djw";
  };

  extraConfig = ''
    BCACHEFS_FS m
  '';

  # Should the testing kernels ever be built on Hydra?
  extraMeta.hydraPlatforms = [];

} // (args.argsOverride or {}))
