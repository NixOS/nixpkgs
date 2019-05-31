{ stdenv, buildPackages, fetchgit, fetchpatch, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "5.0.2019.05.08";
  modDirVersion = "5.0.0";

  src = fetchgit {
    url = "https://evilpiepirate.org/git/bcachefs.git";
    rev = "454bd4f82d85bb42a86b8eb0172b13e86e5788a7";
    sha256 = "1k11yz464lr02yncy231p06ja7w72w9l1nr7cihyiyj1ynzwpdls";
  };

  extraConfig = "BCACHEFS_FS m";

  extraMeta = {
    branch = "master";
    hydraPlatforms = []; # Should the testing kernels ever be built on Hydra?
    maintainers = with stdenv.lib.maintainers; [ davidak chiiruno ];
    platforms = [ "x86_64-linux" ];
  };

} // (args.argsOverride or {}))
