{ lib, buildGoModule, fetchFromGitHub, installShellFiles, testers, okteto }:

buildGoModule rec {
  pname = "okteto";
<<<<<<< HEAD
  version = "2.20.0";
=======
  version = "2.15.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "okteto";
    repo = "okteto";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-AeZ/pp7zWi8liDu247WXetXK/CurV0GUZ/isVdDF3yQ=";
  };

  vendorHash = "sha256-u1oMX2ZplmDGx7ePfA5vKHUuDmWYVCJrYh2HQ23dTfU=";
=======
    hash = "sha256-PxCVBi/GMzyTs9GfIAAPHNbinexw4guSO8ZsyZIOmr4=";
  };

  vendorHash = "sha256-dZ6gzW5R5na5qcHFQqQvKfYb0Bu0kVvVMOaRdtTgkhE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  postPatch = ''
    # Disable some tests that need file system & network access.
    find cmd -name "*_test.go" | xargs rm -f
    rm -f pkg/analytics/track_test.go
  '';

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/okteto/okteto/pkg/config.VersionString=${version}"
  ];

  tags = [ "osusergo" "netgo" "static_build" ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  postInstall = ''
    installShellCompletion --cmd okteto \
      --bash <($out/bin/okteto completion bash) \
      --fish <($out/bin/okteto completion fish) \
      --zsh <($out/bin/okteto completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = okteto;
    command = "HOME=$(mktemp -d) okteto version";
  };

  meta = with lib; {
    description = "Develop your applications directly in your Kubernetes Cluster";
    homepage = "https://okteto.com/";
    license = licenses.asl20;
    maintainers = with maintainers; [ aaronjheng ];
  };
}
