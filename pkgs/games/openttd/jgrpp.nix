{
  fetchFromGitHub,
  openttd,
  zstd,
  ...
}:

openttd.overrideAttrs (oldAttrs: rec {
  pname = "openttd-jgrpp";
  version = "0.65.1";

  src = fetchFromGitHub {
    owner = "JGRennison";
    repo = "OpenTTD-patches";
    rev = "jgrpp-${version}";
    hash = "sha256-nS9yUcCwRkzmC9vIjQvPaRDcdPvHt4Nzt0cyfUX+XTY=";
  };
  patches = [ ];

  buildInputs = oldAttrs.buildInputs ++ [ zstd ];

  meta = {
    homepage = "https://github.com/JGRennison/OpenTTD-patches";
    changelog = "https://github.com/JGRennison/OpenTTD-patches/blob/jgrpp-${version}/jgrpp-changelog.md";
    mainProgram = "openttd";
  };

})
