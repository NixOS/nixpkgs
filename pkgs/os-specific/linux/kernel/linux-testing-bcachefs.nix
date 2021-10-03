{ lib, buildPackages, fetchFromGitHub, fetchpatch, perl, buildLinux, ... } @ args:

buildLinux (args // {
  version = "5.13.0-2021.10.01";
  modDirVersion = "5.13.0";

  src = fetchFromGitHub {
    owner = "koverstreet";
    repo = "bcachefs";
    rev = "4114ced1db465b8f4e7f4d6a78aa11416a9ab5d9";
    sha256 = "sha256-viFC3HHIcjUTDPvloSKKsz9PuSLyvxfYnrtkVUB79mQ=";
  };

  extraConfig = "BCACHEFS_FS m";

  extraMeta = {
    branch = "master";
    hydraPlatforms = []; # Should the testing kernels ever be built on Hydra?
    maintainers = with lib.maintainers; [ davidak chiiruno ];
    platforms = [ "x86_64-linux" ];
  };

} // (args.argsOverride or {}))
