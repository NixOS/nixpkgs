{ stdenv, fetchFromGitHub, perl, buildLinux, ... } @ args:

let
  rev = "4";
in import ./generic.nix (args // rec {
  version = "3.10.65-${rev}-pine64";

  modDirVersion = "3.10.65-v7";

  src = fetchFromGitHub {
      owner = "longsleep";
      repo = "linux-pine64";
      rev = "${version}";
      sha256 = "1mxxpvfwvs51ank94kbhrqa20fh66qlrpv3mg9vf4jif0cj9ns7c";
  };

  features.iwlwifi = true;

  extraMeta.hydraPlatforms = [];
})
