{ stdenv, buildPackages, fetchgit, fetchpatch, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "5.0.2019.04.04";
  modDirVersion = "5.0.0";

  src = fetchgit {
    url = "https://evilpiepirate.org/git/bcachefs.git";
    rev = "d83b992f653d9f742f3f8567dbcfd1f4f72e858f";
    sha256 = "17xipjhkl4arshyj3riwq4pgl2qqcnlfhaga77a430wy22s7plh2";
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
