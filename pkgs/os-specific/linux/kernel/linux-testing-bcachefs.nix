{ stdenv, buildPackages, fetchgit, fetchpatch, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "5.1.2019.07.11";
  modDirVersion = "5.1.0";

  src = fetchgit {
    url = "https://evilpiepirate.org/git/bcachefs.git";
    rev = "44dc1f269553f33cce43628444970efb85a7e802";
    sha256 = "1i32s15r0a844dnp3h9ac37xm9h69g0jn75pqz2gbfrafpk3pac1";
  };

  extraConfig = "BCACHEFS_FS m";

  extraMeta = {
    branch = "master";
    hydraPlatforms = []; # Should the testing kernels ever be built on Hydra?
    maintainers = with stdenv.lib.maintainers; [ davidak chiiruno ];
    platforms = [ "x86_64-linux" ];
  };

} // (args.argsOverride or {}))
