{ stdenv, buildPackages, fetchgit, fetchpatch, perl, buildLinux, ... } @ args:

buildLinux (args // {
  version = "5.2.2019.10.01";
  modDirVersion = "5.2.0";

  src = fetchgit {
    url = "https://evilpiepirate.org/git/bcachefs.git";
    rev = "45920b5139a752bb4f22871b8b916beacc4f9fb9";
    sha256 = "1hi98jckzd8d7whivmgl1ywdfdixhq7la37jagwnwbf8lsqsp25i";
  };

  extraConfig = "BCACHEFS_FS m";

  extraMeta = {
    branch = "master";
    hydraPlatforms = []; # Should the testing kernels ever be built on Hydra?
    maintainers = with stdenv.lib.maintainers; [ davidak chiiruno ];
    platforms = [ "x86_64-linux" ];
  };

} // (args.argsOverride or {}))
