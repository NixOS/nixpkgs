{ lib, buildGoModule, fetchFromGitHub, installShellFiles, testers, kube-linter }:

buildGoModule rec {
  pname = "kube-linter";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "stackrox";
    repo = pname;
    rev = version;
    sha256 = "sha256-/iwNyThgdXAXu1ulf68+X7nA9wE9jEqN7F5wuT5GMwk=";
  };

  vendorHash = "sha256-jWXR7tHYT15h7QSxinYyPaBs5utUmdeWWm+GPpfwiA4=";

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
