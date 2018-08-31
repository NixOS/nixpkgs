{ stdenv, buildPackages, fetchgit, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.16.2018.08.03";
  modDirVersion = "4.16.0";

  src = fetchgit {
    url = "https://evilpiepirate.org/git/bcachefs.git";
    rev = "e7a00a52b57336c04d1043c6fa0a67a7c8301cfb";
    sha256 = "1a0kvpazvvh0rfb9hkyr4zw55ndh060j95fvhf2aaaj9qyc7p7wp";
  };

  extraConfig = "BCACHEFS_FS m";

  extraMeta = {
    branch = "master";
    hydraPlatforms = []; # Should the testing kernels ever be built on Hydra?
    maintainers = with stdenv.lib.maintainers; [ davidak chiiruno ];
  };

} // (args.argsOverride or {}))
