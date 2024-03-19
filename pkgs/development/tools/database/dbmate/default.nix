{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "dbmate";
  version = "2.13.0";

  src = fetchFromGitHub {
    owner = "amacneil";
    repo = "dbmate";
    rev = "refs/tags/v${version}";
    hash = "sha256-4Ur9LGYcC9C2EUWLLppcVSf+PLgfPITbKGp2qLRnxVY=";
  };

  vendorHash = "sha256-le2AWHqTElo95GQJ8jEk3jjNrxu63YyWVtq+CI6+SbY=";

  doCheck = false;

  meta = with lib; {
    description = "Database migration tool";
    mainProgram = "dbmate";
    homepage = "https://github.com/amacneil/dbmate";
    changelog = "https://github.com/amacneil/dbmate/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ manveru ];
  };
}
