{ lib, buildGoModule, fetchFromGitHub, testers, flyctl, installShellFiles }:

buildGoModule rec {
  pname = "flyctl";
<<<<<<< HEAD
  version = "0.1.90";
=======
  version = "0.1.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "superfly";
    repo = "flyctl";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-dgfPhx2IJxkMji6nw+GSg1xHxyh3xjSr7KLdVv9PbUI=";
  };

  vendorHash = "sha256-DnTjkv3lPUNB1WIQ2ncUaafdUP+y1t0UfaPfV4PW7VM=";
=======
    hash = "sha256-0nassGiVjBb/KLMwj/DWSDdW/ymkIJSfoA6fdLyq8YE=";
  };

  vendorHash = "sha256-w/8cCtu+SKhooutKt810pnbGR1a3hWHjhNmzLVU0Zxk=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  subPackages = [ "." ];

  ldflags = [
    "-s" "-w"
    "-X github.com/superfly/flyctl/internal/buildinfo.commit=${src.rev}"
    "-X github.com/superfly/flyctl/internal/buildinfo.buildDate=1970-01-01T00:00:00Z"
    "-X github.com/superfly/flyctl/internal/buildinfo.environment=production"
    "-X github.com/superfly/flyctl/internal/buildinfo.version=${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

<<<<<<< HEAD
  patches = [ ./disable-auto-update.patch ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  preBuild = ''
    go generate ./...
  '';

  preCheck = ''
    HOME=$(mktemp -d)
  '';

  postCheck = ''
    go test ./... -ldflags="-X 'github.com/superfly/flyctl/internal/buildinfo.buildDate=1970-01-01T00:00:00Z'"
  '';

  postInstall = ''
    installShellCompletion --cmd flyctl \
      --bash <($out/bin/flyctl completion bash) \
      --fish <($out/bin/flyctl completion fish) \
      --zsh <($out/bin/flyctl completion zsh)
    ln -s $out/bin/flyctl $out/bin/fly
  '';

  passthru.tests.version = testers.testVersion {
    package = flyctl;
    command = "HOME=$(mktemp -d) flyctl version";
    version = "v${flyctl.version}";
  };

  meta = with lib; {
    description = "Command line tools for fly.io services";
    downloadPage = "https://github.com/superfly/flyctl";
    homepage = "https://fly.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ aaronjanse jsierles techknowlogick viraptor ];
  };
}
