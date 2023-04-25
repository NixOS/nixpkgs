{ lib
, buildNpmPackage
, nodejs_16
, fetchFromGitHub
}:
let
  buildNpmPackage' = buildNpmPackage.override { nodejs = nodejs_16; };
in
buildNpmPackage' rec {
  pname = "docker-compose-language-service";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "compose-language-service";
    rev = "v${version}";
    hash = "sha256-faQvUHzqtCipceGnamVQIlAWCDpo7oX01/zGz9RLjMY=";
  };

  npmDepsHash = "sha256-gWaZMsI1HVIXKZInfgzfH8syzOwU2C6kcKvB2M6KLX4=";

  meta = with lib; {
    description = "Language service for Docker Compose documents";
    homepage = "https://github.com/microsoft/compose-language-service";
    changelog = "https://github.com/microsoft/compose-language-service/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
    mainProgram = "docker-compose-langserver";
  };
}
