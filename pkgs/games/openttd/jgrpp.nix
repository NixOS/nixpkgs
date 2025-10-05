{
  fetchFromGitHub,
  openttd,
  zstd,
  ...
}:

openttd.overrideAttrs (oldAttrs: rec {
  pname = "openttd-jgrpp";
  version = "0.66.1";

  src = fetchFromGitHub {
    owner = "JGRennison";
    repo = "OpenTTD-patches";
    rev = "jgrpp-${version}";
    hash = "sha256-Bw5/fy3duMQDCDfAF6hGE7eQiNo0d9Ag/afG9zM+d30=";
  };
  patches = [ ];

  buildInputs = oldAttrs.buildInputs ++ [ zstd ];

  meta = {
    homepage = "https://github.com/JGRennison/OpenTTD-patches";
    changelog = "https://github.com/JGRennison/OpenTTD-patches/blob/jgrpp-${version}/jgrpp-changelog.md";
    mainProgram = "openttd";
  };

})
