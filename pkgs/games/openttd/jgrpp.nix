{ fetchFromGitHub, openttd, zstd, ... }:

openttd.overrideAttrs (oldAttrs: rec {
  pname = "openttd-jgrpp";
  version = "0.50.3";

  src = fetchFromGitHub rec {
    owner = "JGRennison";
    repo = "OpenTTD-patches";
    rev = "jgrpp-${version}";
    hash = "sha256-VJ8Qd4wiFbX/aY8pEWlh9wEjML0c7P8yrOC1fiQD7ts=";
  };

  buildInputs = oldAttrs.buildInputs ++ [ zstd ];
})
