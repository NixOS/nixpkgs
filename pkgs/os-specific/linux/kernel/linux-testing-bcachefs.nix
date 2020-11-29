{ stdenv, buildPackages, fetchFromGitHub, fetchpatch, perl, buildLinux, ... } @ args:

buildLinux (args // {
  version = "5.9.0-2020.11.20";
  modDirVersion = "5.9.0";

  src = fetchFromGitHub {
    owner = "koverstreet";
    repo = "bcachefs";
    rev = "6a505b63ed3003faf5000f19fd08bbd477d93fbc";
    sha256 = "1rf34gzv9npafp1c3i6lymk3b0gnqp4rb0wl33pw6yrpgnsry3cc";
  };

  extraConfig = "BCACHEFS_FS m";

  extraMeta = {
    branch = "master";
    hydraPlatforms = []; # Should the testing kernels ever be built on Hydra?
    maintainers = with stdenv.lib.maintainers; [ davidak chiiruno ];
    platforms = [ "x86_64-linux" ];
  };

} // (args.argsOverride or {}))
