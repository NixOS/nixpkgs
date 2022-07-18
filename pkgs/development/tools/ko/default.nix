{ lib
, buildGoModule
, fetchFromGitHub
, git
, installShellFiles
}:

buildGoModule rec {
  pname = "ko";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-BwK49dSt3D2BrYvluDOBYIH5qEt59HC1hssHl1D2Heg=";
  };
  vendorSha256 = null;

  nativeBuildInputs = [ installShellFiles ];

  # Pin so that we don't build the several other development tools
  subPackages = ".";

  ldflags = [ "-s" "-w" "-X github.com/google/ko/pkg/commands.Version=${version}" ];

  checkInputs = [ git ];
  preCheck = ''
    # Feed in all the tests for testing
    # This is because subPackages above limits what is built to just what we
    # want but also limits the tests
    getGoDirs() {
      go list ./...
    }

    # resolves some complaints from ko
    export GOROOT="$(go env GOROOT)"
    git init
  '';

  postInstall = ''
    installShellCompletion --cmd ko \
      --bash <($out/bin/ko completion bash) \
      --fish <($out/bin/ko completion fish) \
      --zsh <($out/bin/ko completion zsh)
  '';

  meta = with lib; {
    homepage = "https://github.com/google/ko";
    changelog = "https://github.com/google/ko/releases/tag/v${version}";
    description = "Build and deploy Go applications on Kubernetes";
    longDescription = ''
      ko is a simple, fast container image builder for Go applications.
      It's ideal for use cases where your image contains a single Go application without any/many dependencies on the OS base image (e.g. no cgo, no OS package dependencies).
      ko builds images by effectively executing go build on your local machine, and as such doesn't require docker to be installed. This can make it a good fit for lightweight CI/CD use cases.
      ko also includes support for simple YAML templating which makes it a powerful tool for Kubernetes applications.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ nickcao jk ];
  };
}
