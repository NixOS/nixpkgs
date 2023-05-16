{ lib
, fetchFromGitea
, buildGoModule
<<<<<<< HEAD
, testers
, gitea-actions-runner
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildGoModule rec {
  pname = "gitea-actions-runner";
<<<<<<< HEAD
  version = "0.2.5";
=======
  version = "0.1.8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitea {
    domain = "gitea.com";
    owner = "gitea";
    repo = "act_runner";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-HWJrgZJfI5fOeZvQkmpd6wciJWh1JOmZMlyGHSbgHpc=";
  };

  vendorHash = "sha256-Z61kTbKHSUpt2F6jVUUK4KwMJ0ILT1FI4/62AkNQuZI=";
=======
    hash = "sha256-J67g0jy/5Dfmvu3bSPqH+r9+MuLyl2lZyEZrOovfNJI=";
  };

  vendorHash = "sha256-Ik4n1oB6MWE2djcM5CdDhJKx4IJsZu7eJr5St+T67B4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [
    "-s"
    "-w"
<<<<<<< HEAD
    "-X gitea.com/gitea/act_runner/internal/pkg/ver.version=v${version}"
  ];

  passthru.tests.version = testers.testVersion {
    package = gitea-actions-runner;
    version = "v${version}";
  };

=======
    "-X gitea.com/gitea/act_runner/internal/pkg/ver.version=${version}"
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    mainProgram = "act_runner";
    maintainers = with maintainers; [ techknowlogick ];
    license = licenses.mit;
    changelog = "https://gitea.com/gitea/act_runner/releases/tag/v${version}";
    homepage = "https://gitea.com/gitea/act_runner";
    description = "A runner for Gitea based on act";
  };
}
