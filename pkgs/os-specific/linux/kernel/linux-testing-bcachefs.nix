{ stdenv, buildPackages, fetchFromGitHub, fetchpatch, perl, buildLinux, ... } @ args:

buildLinux (args // {
  version = "5.7.2020.04.04";
  modDirVersion = "5.7.0";

  src = fetchFromGitHub {
    owner = "koverstreet";
    repo = "bcachefs";
    rev = "b1708f0191fcad1b7afa47dd6a7c6b1104c4639d";
    sha256 = "1fnyyl41fy96pn9hh65qp53jmdvygbjl2qwcvbslb5565mpm5875";
  };

  extraConfig = "BCACHEFS_FS m";

  extraMeta = {
    branch = "master";
    hydraPlatforms = []; # Should the testing kernels ever be built on Hydra?
    maintainers = with stdenv.lib.maintainers; [ davidak chiiruno ];
    platforms = [ "x86_64-linux" ];
  };

} // (args.argsOverride or {}))
