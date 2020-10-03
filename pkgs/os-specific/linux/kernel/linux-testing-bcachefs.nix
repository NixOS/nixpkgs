{ stdenv, buildPackages, fetchFromGitHub, fetchpatch, perl, buildLinux, ... } @ args:

buildLinux (args // {
  version = "5.8.0-2020.09.07";
  modDirVersion = "5.8.0";

  src = fetchFromGitHub {
    owner = "koverstreet";
    repo = "bcachefs";
    rev = "fb2821e72648f35d3cff61ac26041d634fd1dacf";
    sha256 = "0f9hx6fz27rm8h1lk9868v727klvyzcbw6hcgm5mypbfq1nqirdy";
  };

  extraConfig = "BCACHEFS_FS m";

  extraMeta = {
    branch = "master";
    hydraPlatforms = []; # Should the testing kernels ever be built on Hydra?
    maintainers = with stdenv.lib.maintainers; [ davidak chiiruno ];
    platforms = [ "x86_64-linux" ];
  };

} // (args.argsOverride or {}))
