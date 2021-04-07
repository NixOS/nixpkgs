{ fetchFromGitHub, openttd, ... }:

openttd.overrideAttrs (oldAttrs: rec {
  pname = "openttd-jgrpp";
  version = "0.40.5";

  src = fetchFromGitHub rec {
    owner = "JGRennison";
    repo = "OpenTTD-patches";
    rev = "jgrpp-${version}";
    sha256 = "sha256-g1RmgVjefOrOVLTvFBiPEd19aLoFvB9yX/hMiKgGcGw=";
  };
})
