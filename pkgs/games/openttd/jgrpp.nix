{ fetchFromGitHub, openttd, zstd, ... }:

openttd.overrideAttrs (oldAttrs: rec {
  pname = "openttd-jgrpp";
  version = "0.54.4";

  src = fetchFromGitHub rec {
    owner = "JGRennison";
    repo = "OpenTTD-patches";
    rev = "jgrpp-${version}";
    hash = "sha256-bTpHlKffQbANXIrAn9WSEK/PEzBW1nzaHhGKIyclAo0=";
  };

  buildInputs = oldAttrs.buildInputs ++ [ zstd ];
})
