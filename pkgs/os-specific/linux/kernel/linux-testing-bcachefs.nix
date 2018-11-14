{ stdenv, buildPackages, fetchgit, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.18.2018.10.12";
  modDirVersion = "4.18.0";

  src = fetchgit {
    url = "https://evilpiepirate.org/git/bcachefs.git";
    rev = "d7f6da1d60ec24266301231538ff6f09716537ed";
    sha256 = "05d7dh41nc35www8vmrn47wlf2mr2b8i4rm15vq3zgm32d0xv3lk";
  };

  extraConfig = "BCACHEFS_FS m";

  extraMeta = {
    branch = "master";
    hydraPlatforms = []; # Should the testing kernels ever be built on Hydra?
    maintainers = with stdenv.lib.maintainers; [ davidak chiiruno ];
    platforms = [ "x86_64-linux" ];
  };

} // (args.argsOverride or {}))
