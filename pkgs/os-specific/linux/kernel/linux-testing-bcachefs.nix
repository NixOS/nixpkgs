{ stdenv, buildPackages, fetchFromGitHub, fetchpatch, perl, buildLinux, ... } @ args:

buildLinux (args // {
  version = "5.7.2020.04.04";
  modDirVersion = "5.7.0";

  src = fetchFromGitHub {
    owner = "koverstreet";
    repo = "bcachefs";
    rev = "9f34144308fcabb5dcf718406a8c90795e6fd481";
    sha256 = "0z1aqallj3v20w09gjd2c9hf9kin6a8gnnwpkm37abvaddjh3kf6";
  };

  extraConfig = "BCACHEFS_FS y";

  extraMeta = {
    branch = "master";
    hydraPlatforms = []; # Should the testing kernels ever be built on Hydra?
    maintainers = with stdenv.lib.maintainers; [ davidak chiiruno ];
    platforms = [ "x86_64-linux" ];
  };

} // (args.argsOverride or {}))
