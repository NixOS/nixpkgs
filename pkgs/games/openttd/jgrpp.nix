{ fetchFromGitHub, openttd, zstd, ... }:

openttd.overrideAttrs (oldAttrs: rec {
  pname = "openttd-jgrpp";
  version = "0.47.1";

  src = fetchFromGitHub rec {
    owner = "JGRennison";
    repo = "OpenTTD-patches";
    rev = "jgrpp-${version}";
    hash = "sha256-AMd2KXy/ODByeV9CkEd51KbE/+fZ8Us3WzsWCnn7nh0=";
  };

  buildInputs = oldAttrs.buildInputs ++ [ zstd ];
})
