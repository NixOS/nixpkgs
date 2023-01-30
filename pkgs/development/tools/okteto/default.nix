{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "okteto";
  version = "2.11.1";

  src = fetchFromGitHub {
    owner = "okteto";
    repo = "okteto";
    rev = version;
    hash = "sha256-Eprsy/wd5lMBXk3yVGhofYD9ZBfdmjGMwXZ61RMgd4k=";
  };

  vendorHash = "sha256-Yi+4fGCHLH/kA4DuPI2uQ/27xhMd4cPFkTWlI6Bc13A=";

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

  meta = with lib; {
    description = "Develop your applications directly in your Kubernetes Cluster";
    homepage = "https://okteto.com/";
    license = licenses.asl20;
    maintainers = with maintainers; [ aaronjheng ];
  };
}
