{ stdenv, buildPackages, fetchgit, fetchpatch, perl, buildLinux, ... } @ args:

buildLinux (args // {
  version = "5.3.2020.03.25";
  modDirVersion = "5.3.0";

  src = fetchgit {
    url = "https://evilpiepirate.org/git/bcachefs.git";
    rev = "96b991466ac851ea3c7adbd2e30184837573e2a0";
    sha256 = "1x6h2p8j8n727jywyc24k81i169xj645pb5wav3hvn57qja1z3b3";
  };

  extraConfig = "BCACHEFS_FS m";

  extraMeta = {
    branch = "master";
    hydraPlatforms = []; # Should the testing kernels ever be built on Hydra?
    maintainers = with stdenv.lib.maintainers; [ davidak chiiruno ];
    platforms = [ "x86_64-linux" ];
  };

} // (args.argsOverride or {}))
