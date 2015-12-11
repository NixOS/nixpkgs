{ stdenv, fetchgit, perl, buildLinux, ... } @ args:

let

  rev = "5eb40d45b291ee129cbfac2073f1ca7aa32ff4c5";

in import ./generic.nix (args // rec {
  version = "4.2.0-${rev}";

  modDirVersion = "4.2.0";

  src = fetchgit {
    url = "https://github.com/tobetter/linux";
    branchName = "odroidxu4-v4.2";
    sha256 = "0jg203wswdkdanxsqycgv1jfx2a05z3p1b44r4xgaqmfcc6fsx70";
    inherit rev;
  };

  features.iwlwifi = true;

  extraMeta.hydraPlatforms = [];
})
