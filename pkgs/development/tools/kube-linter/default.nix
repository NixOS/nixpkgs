{ lib, buildGoModule, fetchFromGitHub, installShellFiles, testers, kube-linter }:

buildGoModule rec {
  pname = "kube-linter";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "stackrox";
    repo = pname;
    rev = version;
    sha256 = "XAsPbl9fqYk2nhDxRg5wyPwciwSpfigoBZ4hzdWAVgw=";
  };

  vendorSha256 = "sha256-0bjAIHSjw0kHrh9CzJHv1UAaBJDn6381055eOHufvCw=";

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
    license = licenses.asl20;
    maintainers = with maintainers; [ mtesseract stehessel ];
    platforms = platforms.all;
  };
}
