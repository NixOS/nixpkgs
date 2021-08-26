{ lib
, buildGoModule
, fetchFromGitHub
, git
, installShellFiles
}:

buildGoModule rec {
  pname = "ko";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "google";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-LoOXZY4uF7GSS3Dh/ozCsLJTxgmPmZZuEisJ4ShjCBc=";
  };
  vendorSha256 = null;
  # Don't build the legacy main.go or test dir
  excludedPackages = "\\(cmd/ko\\|test\\)";
  nativeBuildInputs = [ installShellFiles ];

  ldflags = [ "-s" "-w" "-X github.com/google/ko/pkg/commands.Version=${version}" ];

  checkInputs = [ git ];
  preCheck = ''
    # resolves some complaints from ko
    export GOROOT="$(go env GOROOT)"
    git init
  '';

  postInstall = ''
    installShellCompletion --cmd ko \
      --bash <($out/bin/ko completion) \
      --zsh <($out/bin/ko completion --zsh)
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
