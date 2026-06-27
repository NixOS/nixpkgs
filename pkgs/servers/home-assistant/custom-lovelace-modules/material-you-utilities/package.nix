{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "material-you-utilities";
  version = "2.1.16";

  src = fetchFromGitHub {
    owner = "Nerwyn";
    repo = "material-you-utilities";
    tag = version;
    hash = "sha256-s8VVV2KmiJ3auQPRwVRWHonYlVWkExC3quRANfW295U=";
  };

  npmDepsHash = "sha256-D18gwO8zO7lKbaRhj+QaeGzkE7zqXc3KGvz9am4rrFY=";

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
