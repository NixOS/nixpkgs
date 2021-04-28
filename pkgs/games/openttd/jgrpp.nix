{ fetchFromGitHub, openttd, ... }:

openttd.overrideAttrs (oldAttrs: rec {
  pname = "openttd-jgrpp";
  version = "0.41.0";

  src = fetchFromGitHub rec {
    owner = "JGRennison";
    repo = "OpenTTD-patches";
    rev = "jgrpp-${version}";
    sha256 = "sha256-DrtxqXyeqA+X4iLTvTSPFDKDoLCyVd458+nJWc+9MF4=";
  };
})
