{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "docker-compose-language-service";
<<<<<<< HEAD
  version = "0.2.0";
=======
  version = "0.1.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "compose-language-service";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-UBnABi7DMKrAFkRA8H6us/Oq4yM0mJ+kwOm0Rt8XnGw=";
  };

  npmDepsHash = "sha256-G1X9WrnwN6wM9S76PsGrPTmmiMBUKu4T2Al3HH3Wo+w=";
=======
    hash = "sha256-faQvUHzqtCipceGnamVQIlAWCDpo7oX01/zGz9RLjMY=";
  };

  npmDepsHash = "sha256-gWaZMsI1HVIXKZInfgzfH8syzOwU2C6kcKvB2M6KLX4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Language service for Docker Compose documents";
    homepage = "https://github.com/microsoft/compose-language-service";
    changelog = "https://github.com/microsoft/compose-language-service/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
    mainProgram = "docker-compose-langserver";
  };
}
