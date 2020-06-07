{ stdenv, buildPackages, fetchgit, fetchpatch, perl, buildLinux, ... } @ args:

buildLinux (args // {
  version = "5.6.2020.06.04";
  modDirVersion = "5.6.0";

  src = fetchgit {
    url = "https://evilpiepirate.org/git/bcachefs.git";
    rev = "c9b4a210f946889f56654dda24dd8ced3b1aac24";
    sha256 = "062mh12kfw0wnz5jkm9w1vvk2bf3rkgs4r8rkikmdlscamyikgli";
  };
  

  extraConfig = "BCACHEFS_FS m";

  extraMeta = {
    branch = "master";
    hydraPlatforms = []; # Should the testing kernels ever be built on Hydra?
    maintainers = with stdenv.lib.maintainers; [ davidak chiiruno ];
    platforms = [ "x86_64-linux" ];
  };

} // (args.argsOverride or {}))
