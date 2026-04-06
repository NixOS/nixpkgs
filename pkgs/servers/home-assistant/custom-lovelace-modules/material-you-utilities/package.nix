{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "material-you-utilities";
  version = "2.1.5";

  src = fetchFromGitHub {
    owner = "Nerwyn";
    repo = "material-you-utilities";
    tag = version;
    hash = "sha256-Z4O7HsV20/5aUvblzR7SLLONr3PrV1Jk91D2badaDl8=";
  };

  npmDepsHash = "sha256-omcnqwwJPYWF2A0hn4ob+mro6cX/ohIh15MrWoLcSzU=";

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp dist/material-you-utilities.min.js $out/

    runHook postInstall
  '';

  passthru.entrypoint = "material-you-utilities.min.js";

  meta = {
    description = "Material Design 3 color theme generation and Home Assistant component modification";
    homepage = "https://github.com/Nerwyn/material-you-utilities";
    changelog = "https://github.com/Nerwyn/material-you-utilities/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
