{
  fetchFromGitHub,
  openttd,
  zstd,
  ...
}:

openttd.overrideAttrs (oldAttrs: rec {
  pname = "openttd-jgrpp";
  version = "0.67.0";

  src = fetchFromGitHub {
    owner = "JGRennison";
    repo = "OpenTTD-patches";
    rev = "jgrpp-${version}";
    hash = "sha256-L6j/P9iHL9QK6Zi2nkbbmAx0zXggwtASIYAnXqDSCfo=";
  };
  patches = [ ];

  buildInputs = oldAttrs.buildInputs ++ [ zstd ];

  meta = {
    homepage = "https://github.com/JGRennison/OpenTTD-patches";
    changelog = "https://github.com/JGRennison/OpenTTD-patches/blob/jgrpp-${version}/jgrpp-changelog.md";
    mainProgram = "openttd";
  };

})
