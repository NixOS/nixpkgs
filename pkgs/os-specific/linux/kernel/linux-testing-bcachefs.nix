{ stdenv, buildPackages, fetchgit, fetchpatch, perl, buildLinux, ... } @ args:

buildLinux (args // {
  version = "5.1.2019.08.21";
  modDirVersion = "5.1.0";

  src = fetchgit {
    url = "https://evilpiepirate.org/git/bcachefs.git";
    rev = "ece184f718c2b678738bc2c42906e90eeb8ba7dc";
    sha256 = "08cbisgcww8fklpxwqkm2c8ddz0mm7v11ycp7ch0kalwdv2f81lr";
  };

  extraConfig = "BCACHEFS_FS m";

  extraMeta = {
    branch = "master";
    hydraPlatforms = []; # Should the testing kernels ever be built on Hydra?
    maintainers = with stdenv.lib.maintainers; [ davidak chiiruno ];
    platforms = [ "x86_64-linux" ];
  };

} // (args.argsOverride or {}))
