{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "newman";
  version = "6.1.2";

  src = fetchFromGitHub {
    owner = "postmanlabs";
    repo = "newman";
    rev = "refs/tags/v${version}";
    hash = "sha256-BQVJNOTVtB1g6+PsHJ5nbN9X7b33d/3qkSUcHTMexB0=";
  };

  npmDepsHash = "sha256-kr4LozGpmmU5g2LIKd+SaKbHsOM6hnlflM79c4tFII8=";

  dontNpmBuild = true;

  meta = with lib; {
    homepage = "https://www.getpostman.com";
    description = "A command-line collection runner for Postman";
    mainProgram = "newman";
    changelog = "https://github.com/postmanlabs/newman/releases/tag/v${version}";
    maintainers = with maintainers; [ freezeboy ];
    license = licenses.asl20;
  };
}
