{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "material-you-utilities";
  version = "2.1.23";

  src = fetchFromGitHub {
    owner = "Nerwyn";
    repo = "material-you-utilities";
    tag = version;
    hash = "sha256-LXnFPWPJ8DF//QZ9/55gwmKQlrAydChK4ABzdPQ+1rk=";
  };

  npmDepsHash = "sha256-Any4XiECizCr8oyfw9EwXesBQP0DWOGhqjnBS8zl53c=";

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
