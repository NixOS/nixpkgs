{ lib
, buildGoModule
, fetchFromGitHub
, git
, installShellFiles
}:

buildGoModule rec {
  pname = "ko";
<<<<<<< HEAD
  version = "0.14.1";
=======
  version = "0.13.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "ko-build";
    repo = pname;
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-jBysfeoZ9W94c07xFODBASrWGJbZRHsUODfEul9f4Ug=";
  };

  vendorHash = null;
=======
    rev = "v${version}";
    sha256 = "sha256-KVJqqvp46BAUscG5Xj/g4ThUXKFsuJdzEB++uBskFiw=";
  };

  vendorSha256 = null;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ installShellFiles ];

  # Pin so that we don't build the several other development tools
  subPackages = ".";

  ldflags = [ "-s" "-w" "-X github.com/google/ko/pkg/commands.Version=${version}" ];

<<<<<<< HEAD
  checkFlags = [
    # requires docker daemon
    "-skip=TestNewPublisherCanPublish"
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeCheckInputs = [ git ];
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

    # ko tests will fail if any of those env are set, as ko tries
    # to make sure it can build and target multiple GOOS/GOARCH
    unset GOOS GOARCH GOARM
  '';

  postInstall = ''
    installShellCompletion --cmd ko \
      --bash <($out/bin/ko completion bash) \
      --fish <($out/bin/ko completion fish) \
      --zsh <($out/bin/ko completion zsh)
  '';

  meta = with lib; {
    homepage = "https://github.com/ko-build/ko";
    changelog = "https://github.com/ko-build/ko/releases/tag/v${version}";
    description = "Build and deploy Go applications on Kubernetes";
    longDescription = ''
      ko is a simple, fast container image builder for Go applications.
      It's ideal for use cases where your image contains a single Go application without any/many dependencies on the OS base image (e.g. no cgo, no OS package dependencies).
      ko builds images by effectively executing go build on your local machine, and as such doesn't require docker to be installed. This can make it a good fit for lightweight CI/CD use cases.
      ko also includes support for simple YAML templating which makes it a powerful tool for Kubernetes applications.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ nickcao jk vdemeester developer-guy ];
  };
}
