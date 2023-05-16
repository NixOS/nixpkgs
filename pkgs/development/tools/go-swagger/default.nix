{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "go-swagger";
<<<<<<< HEAD
  version = "0.30.5";
=======
  version = "0.30.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "go-swagger";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-38Ytv/mQVi0xTydFTPNizJIjYPL+lOws6jHsRjxSC4o=";
  };

  vendorHash = "sha256-TqoTzxPGF0BBUfLtYWkljRcmr08m4zo5iroWMklxL7U=";
=======
    hash = "sha256-5jnSuJqy5oaRxmZh2rr1hoBJPS4S9s0FhMZ4AY61w1I=";
  };

  vendorHash = "sha256-EVsJP04yBiquux5LRR23bGRzrLiXBO9VA8UGlZEpgi8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = false;

  subPackages = [ "cmd/swagger" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/go-swagger/go-swagger/cmd/swagger/commands.Version=${version}"
    "-X github.com/go-swagger/go-swagger/cmd/swagger/commands.Commit=${src.rev}"
  ];

  meta = with lib; {
    description = "Golang implementation of Swagger 2.0, representation of your RESTful API";
    homepage = "https://github.com/go-swagger/go-swagger";
    changelog = "https://github.com/go-swagger/go-swagger/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ kalbasit ];
    mainProgram = "swagger";
  };
}
