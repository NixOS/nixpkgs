{ fetchFromGitHub, openttd, ... }:

openttd.overrideAttrs (oldAttrs: rec {
  pname = "openttd-jgrpp";
  version = "0.43.1";

  src = fetchFromGitHub rec {
    owner = "JGRennison";
    repo = "OpenTTD-patches";
    rev = "jgrpp-${version}";
    sha256 = "sha256-nCZ3UN2BdpDGbW0CKX/ijxlA3cQ7FPflajQ5TBM1Hdk=";
  };
})
