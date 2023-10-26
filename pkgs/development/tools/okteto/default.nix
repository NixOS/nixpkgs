{ lib, buildGoModule, fetchFromGitHub, installShellFiles, testers, okteto }:

buildGoModule rec {
  pname = "okteto";
  version = "2.21.0";

  src = fetchFromGitHub {
    owner = "okteto";
    repo = "okteto";
    rev = version;
    hash = "sha256-4arcK/g9j/lv1HWP7rvhAXJpYRMKgmSbGPZjy2UkhyE=";
  };

  vendorHash = "sha256-u1oMX2ZplmDGx7ePfA5vKHUuDmWYVCJrYh2HQ23dTfU=";

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
