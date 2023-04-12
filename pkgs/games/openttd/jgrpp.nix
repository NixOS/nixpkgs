{ fetchFromGitHub, openttd, zstd, ... }:

openttd.overrideAttrs (oldAttrs: rec {
  pname = "openttd-jgrpp";
  version = "0.52.1";

  src = fetchFromGitHub rec {
    owner = "JGRennison";
    repo = "OpenTTD-patches";
    rev = "jgrpp-${version}";
    hash = "sha256-1coNn+L4DrkqyOOnDyNpzCnIe/pOzGSB5+DNs8ETdGU=";
  };

  buildInputs = oldAttrs.buildInputs ++ [ zstd ];
})
