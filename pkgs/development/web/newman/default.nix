{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "newman";
  version = "6.1.1";

  src = fetchFromGitHub {
    owner = "postmanlabs";
    repo = "newman";
    rev = "refs/tags/v${version}";
    hash = "sha256-CHlch4FoaW42oWxlaAEuNBLTM1hSwLK+nvBfE17GNHU=";
  };

  npmDepsHash = "sha256-ez6FXuu1gMBfJvgmOKs+zoUVMWwBPgJH33BbbLNL0Vk=";

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
