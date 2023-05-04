{ fetchFromGitHub, openttd, zstd, ... }:

openttd.overrideAttrs (oldAttrs: rec {
  pname = "openttd-jgrpp";
  version = "0.53.1";

  src = fetchFromGitHub rec {
    owner = "JGRennison";
    repo = "OpenTTD-patches";
    rev = "jgrpp-${version}";
    hash = "sha256-+5AOsop3x1fkX5UfxMFLhrTLeSnt+E0PYoU5n31N3f4=";
  };

  buildInputs = oldAttrs.buildInputs ++ [ zstd ];
})
