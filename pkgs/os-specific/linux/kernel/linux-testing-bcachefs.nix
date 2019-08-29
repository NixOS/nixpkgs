{ stdenv, buildPackages, fetchgit, fetchpatch, perl, buildLinux, ... } @ args:

buildLinux (args // {
  version = "5.2.2019.09.24";
  modDirVersion = "5.2.0";

  src = fetchgit {
    url = "https://evilpiepirate.org/git/bcachefs.git";
    rev = "5a3a4087af27aa10da5f23cb174a439946153584";
    sha256 = "1yn40n2iyflbfv1z8l86nixv8wlybg7abz49nq5k6hmf7r9z56mk";
  };

  extraConfig = "BCACHEFS_FS m";

  extraMeta = {
    branch = "master";
    hydraPlatforms = []; # Should the testing kernels ever be built on Hydra?
    maintainers = with stdenv.lib.maintainers; [ davidak chiiruno ];
    platforms = [ "x86_64-linux" ];
  };

} // (args.argsOverride or {}))
