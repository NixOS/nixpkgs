{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "squoosh-cli";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "GoogleChromeLabs";
    repo = "squoosh";
    rev = "918c596cba36a46ff3d7aa8ffd69580bd22528e2";
    hash = "sha256-LYpNT8DvtAbdGJ/j8fLEnnruAJoJtQ2H6qm8WPCEXnI=";
  };

  sourceRoot = "${src.name}/cli";

  npmDepsHash = "sha256-UcqQA4gHQKZu/c+39vXupQWl/HliTtyex8cP6lQ1TMc=";

  dontNpmBuild = true;

  meta = {
    description = "Make images smaller using best-in-class codecs";
    homepage = "https://github.com/GoogleChromeLabs/squoosh";
    license = lib.licenses.asl20;
    mainProgram = "squoosh-cli";
    maintainers = with lib.maintainers; [ kidonng ];
  };
}
