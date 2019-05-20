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

  kernelPatches = [
    { name = "export-bio_iov_iter_get_pages";
      patch = fetchpatch {
        name = "export-bio_iov_iter_get_pages.patch";
        url = "https://evilpiepirate.org/git/bcachefs.git/patch/?id=bd8be01aa04eb9cc33fcdce89ac6e0fac0ae0fcf";
        sha256 = "0h5z98krx8077wwhiqp3bwc1h4nwnifxsn8mpxr2lcxnqmky3hz0";
      }; }
  ];

  extraMeta = {
    branch = "master";
    hydraPlatforms = []; # Should the testing kernels ever be built on Hydra?
    maintainers = with stdenv.lib.maintainers; [ davidak chiiruno ];
    platforms = [ "x86_64-linux" ];
  };

} // (args.argsOverride or {}))
