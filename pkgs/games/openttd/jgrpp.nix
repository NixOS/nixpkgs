{ fetchFromGitHub, openttd, zstd, ... }:

openttd.overrideAttrs (oldAttrs: rec {
  pname = "openttd-jgrpp";
  version = "0.54.1";

  src = fetchFromGitHub rec {
    owner = "JGRennison";
    repo = "OpenTTD-patches";
    rev = "jgrpp-${version}";
    hash = "sha256-MfYh2a3wjWB/5zgTE8AAIREI2OEhykqF0Rad7I+912U=";
  };

  buildInputs = oldAttrs.buildInputs ++ [ zstd ];
})
