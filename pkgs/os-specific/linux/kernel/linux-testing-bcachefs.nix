{ stdenv, buildPackages, fetchgit, perl, buildLinux, ... } @ args:

buildLinux (args // rec {
  version = "4.18.2018.08.31";
  modDirVersion = "4.18.0";

  src = fetchgit {
    url = "https://evilpiepirate.org/git/bcachefs.git";
    rev = "9c08efd02b827e6ee2a6e5a751045c6c6bd484d4";
    sha256 = "0xnkg0fpilmwckyb1drspggv3ibx8vkqic9ai53d5vx2rrnvvafw";
  };

  extraConfig = "BCACHEFS_FS m";

  extraMeta = {
    branch = "master";
    hydraPlatforms = []; # Should the testing kernels ever be built on Hydra?
    maintainers = with stdenv.lib.maintainers; [ davidak chiiruno ];
    platforms = [ "x86_64-linux" ];
  };

} // (args.argsOverride or {}))
