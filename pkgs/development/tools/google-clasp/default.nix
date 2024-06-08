{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "clasp";
  version = "2.4.2";

  src = fetchFromGitHub {
    owner = "google";
    repo = "clasp";
    rev = "refs/tags/v${version}";
    hash = "sha256-Cnnqbxjfx7hlRYIDtbjSbDO0QBHqLsleIGrAUQDLaCw=";
  };

  npmDepsHash = "sha256-4oYpGBpk4WBVnE1HNYmRRGHZgcPgta2YQB00YyWvbiI=";

  # `npm run build` tries installing clasp globally
  npmBuildScript = [ "compile" ];

  meta = with lib; {
    description = "Develop Apps Script Projects locally";
    mainProgram = "clasp";
    homepage = "https://github.com/google/clasp#readme";
    changelog = "https://github.com/google/clasp/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ natsukium ];
  };
}
