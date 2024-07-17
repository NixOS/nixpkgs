{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs,
  python3,
}:

buildNpmPackage rec {
  pname = "jitsi-excalidraw-backend";
  version = "17";

  src = fetchFromGitHub {
    owner = "jitsi";
    repo = "excalidraw-backend";
    rev = "x${version}";
    hash = "sha256-aQePkVA8KRL06VewiD0ePRpj88pAItcV7B2SBnRRtCs=";
  };

  npmDepsHash = "sha256-BJqjaqTeg5i+ECGMuiBYVToK2i2XCOVP9yeDFz6nP4k=";

  nativeBuildInputs = [ python3 ];

  installPhase = ''
    mkdir -p $out/share
    cp -r {node_modules,dist} $out/share
  '';

  postFixup = ''
    makeWrapper ${nodejs}/bin/node $out/bin/jitsi-excalidraw-backend \
      --add-flags dist/index.js \
      --chdir $out/share
  '';

  meta = with lib; {
    description = "Excalidraw collaboration backend for Jitsi";
    homepage = "https://github.com/jitsi/excalidraw-backend";
    license = licenses.mit;
    maintainers = with maintainers; [ camillemndn ];
    mainProgram = "jitsi-excalidraw-backend";
  };
}
