{ stdenv, buildPackages, fetchgit, fetchpatch, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "5.1.2019.07.13";
  modDirVersion = "5.1.0";

  src = fetchgit {
    url = "https://evilpiepirate.org/git/bcachefs.git";
    rev = "22776fe9902b0b06d6aa18cd4c7f0c5ad35a95fa";
    sha256 = "0ly4vxawj8skh55c541zll3b8g6igiaq7aj33fklfjh0icmgzs60";
  };

  extraConfig = "BCACHEFS_FS m";

  extraMeta = {
    branch = "master";
    hydraPlatforms = []; # Should the testing kernels ever be built on Hydra?
    maintainers = with stdenv.lib.maintainers; [ davidak chiiruno ];
    platforms = [ "x86_64-linux" ];
  };

} // (args.argsOverride or {}))
