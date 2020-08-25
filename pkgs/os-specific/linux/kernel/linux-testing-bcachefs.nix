{ stdenv, buildPackages, fetchFromGitHub, fetchpatch, perl, buildLinux, ... } @ args:

buildLinux (args // {
  version = "5.7.2020.08.12";
  modDirVersion = "5.7.0";

  src = fetchFromGitHub {
    owner = "koverstreet";
    repo = "bcachefs";
    rev = "86fa1258a3ef59adccdd1534e55ef773b82c4cb7";
    sha256 = "0g1yd9ga9p0l3hiyvsp9hhzfhvl0h7jzh0rsg6xjf0f001jlfpmb";
  };

  extraConfig = "BCACHEFS_FS m";

  extraMeta = {
    branch = "master";
    hydraPlatforms = []; # Should the testing kernels ever be built on Hydra?
    maintainers = with stdenv.lib.maintainers; [ davidak chiiruno ];
    platforms = [ "x86_64-linux" ];
  };

} // (args.argsOverride or {}))
