{ stdenv, buildPackages, fetchgit, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.20.2019.03.13";
  modDirVersion = "4.20.0";

  src = fetchgit {
    url = "https://evilpiepirate.org/git/bcachefs.git";
    rev = "986543d24e08a0c0308472403b230d546e7ecbbb";
    sha256 = "07h9l47wijhlx3xnyxnj8kv1zb9yf2x0gag8n606yq6wn9r523hv";
  };

  extraConfig = "BCACHEFS_FS m";

  extraMeta = {
    branch = "master";
    hydraPlatforms = []; # Should the testing kernels ever be built on Hydra?
    maintainers = with stdenv.lib.maintainers; [ davidak chiiruno ];
    platforms = [ "x86_64-linux" ];
  };

} // (args.argsOverride or {}))
