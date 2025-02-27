{ fetchFromGitHub, openttd, zstd, ... }:

openttd.overrideAttrs (oldAttrs: rec {
  pname = "openttd-jgrpp";
  version = "0.64.1";

  src = fetchFromGitHub rec {
    owner = "JGRennison";
    repo = "OpenTTD-patches";
    rev = "jgrpp-${version}";
    hash = "sha256-SdtlI/b8Uz7I5z3lF0a+WBQMo/fAS75nUh4gWC9Lwuk=";
  };
  patches = [];

  buildInputs = oldAttrs.buildInputs ++ [ zstd ];

  meta = {
    homepage = "https://github.com/JGRennison/OpenTTD-patches";
    changelog = "https://github.com/JGRennison/OpenTTD-patches/blob/jgrpp-${version}/jgrpp-changelog.md";
    mainProgram = "openttd";
  };

})
