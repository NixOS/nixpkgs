{ stdenv, buildPackages, fetchgit, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.20.2019.02.09";
  modDirVersion = "4.20.0";

  src = fetchgit {
    url = "https://evilpiepirate.org/git/bcachefs.git";
    rev = "09a546543006b60d44c4c51e7b40cd3ec7837a5e";
    sha256 = "0p187vp9df0nnhawql0f2bj2sdim0f2b424106d41yxc8ayhz0d9";
  };

  extraConfig = "BCACHEFS_FS m";

  extraMeta = {
    branch = "master";
    hydraPlatforms = []; # Should the testing kernels ever be built on Hydra?
    maintainers = with stdenv.lib.maintainers; [ davidak chiiruno ];
    platforms = [ "x86_64-linux" ];
  };

} // (args.argsOverride or {}))
