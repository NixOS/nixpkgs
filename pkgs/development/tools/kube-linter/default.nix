{ lib, buildGoModule, fetchFromGitHub, installShellFiles, testers, kube-linter }:

buildGoModule rec {
  pname = "kube-linter";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "stackrox";
    repo = pname;
    rev = version;
    sha256 = "sha256-FEiUnJFmrHj97aSjfJtsjS9Qy4A6mzXicIrJZdgZbag=";
  };

  vendorSha256 = "sha256-5dsM5jfD/apRs5NT/XqM8eHEgiyGQHHG3MG6cOFQKr8=";

  ldflags = [
    "-s" "-w" "-X golang.stackrox.io/kube-linter/internal/version.version=${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd kube-linter \
      --bash <($out/bin/kube-linter completion bash) \
      --fish <($out/bin/kube-linter completion fish) \
      --zsh <($out/bin/kube-linter completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = kube-linter;
    command = "kube-linter version";
  };

  meta = with lib; {
    description = "A static analysis tool that checks Kubernetes YAML files and Helm charts";
    homepage = "https://kubelinter.io";
    changelog   = "https://github.com/stackrox/kube-linter/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ mtesseract stehessel ];
    platforms = platforms.all;
  };
}
