{ lib, buildGoModule, fetchFromGitHub, installShellFiles, testers, kube-linter }:

buildGoModule rec {
  pname = "kube-linter";
  version = "0.6.8";

  src = fetchFromGitHub {
    owner = "stackrox";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-abfNzf+84BWHpvLQZKyzl7WBt7UHj2zqzKq3VCqAwwY=";
  };

  vendorHash = "sha256-FUkGiJ/6G9vSYtAj0v9GT4OINbO3d/OKlJ0YwhONftY=";

  ldflags = [
    "-s" "-w" "-X golang.stackrox.io/kube-linter/internal/version.version=${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  checkFlags = [ "-skip=TestCreateContextsWithIgnorePaths" ];

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
    changelog   = "https://github.com/stackrox/kube-linter/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ mtesseract stehessel Intuinewin ];
    platforms = platforms.all;
  };
}
