{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "graphqurl";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "hasura";
    repo = "graphqurl";
    rev = "v${version}";
    hash = "sha256-0dR8lLD0yatAvE3kA90cNOzVRTFpQmzN1l13hdFr3TM=";
  };

  npmDepsHash = "sha256-2kLmhNFO/ySa6S9rBNYCePmsYXWz006IxiOJ7ZUkgPw=";

  dontNpmBuild = true;

  meta = {
    description = "CLI and JS library for making GraphQL queries";
    homepage = "https://github.com/hasura/graphqurl";
    license = lib.licenses.asl20;
    mainProgram = "gq";
    maintainers = with lib.maintainers; [ bbigras ];
  };
}
