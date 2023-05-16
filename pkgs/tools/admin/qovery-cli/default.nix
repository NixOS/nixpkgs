{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, qovery-cli
, testers
}:

buildGoModule rec {
  pname = "qovery-cli";
<<<<<<< HEAD
  version = "0.69.1";
=======
  version = "0.58.10";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Qovery";
    repo = pname;
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-CT8Quz8m+ZB4VsxOrvoSyka3A+AcPC5QpHx8YJkSJ+4=";
  };

  vendorHash = "sha256-U/yV+6WV8Oc0gLcYFyfOeBzzJdNwyyBk3jPRkH3LUrc=";
=======
    rev = "v${version}";
    hash = "sha256-akWnbwogJaaVi3dmPg/qWYqqW9xdLpg7EUpIkCmS1xE=";
  };

  vendorHash = "sha256-WeHcB1yETbnTVxtccPf3q0JNwLDbTJyKKme02Xnfy60=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd ${pname} \
      --bash <($out/bin/${pname} completion bash) \
      --fish <($out/bin/${pname} completion fish) \
      --zsh <($out/bin/${pname} completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = qovery-cli;
    command = "HOME=$(mktemp -d); ${pname} version";
  };

  meta = with lib; {
    description = "Qovery Command Line Interface";
    homepage = "https://github.com/Qovery/qovery-cli";
    changelog = "https://github.com/Qovery/qovery-cli/releases/tag/v${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
