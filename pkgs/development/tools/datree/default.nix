{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
, testers
, datree
}:

buildGoModule rec {
  pname = "datree";
  version = "1.8.12";

  src = fetchFromGitHub {
    owner = "datreeio";
    repo = "datree";
    rev = "refs/tags/${version}";
    hash = "sha256-xuaiho5hKSFcwCj2P5QGyvGmPUbcErIbVkkX5kGii8E=";
  };

  vendorHash = "sha256-mkVguYzjNGgFUdATjGfenCx3h97LS3SEOkYo3CuP9fA=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/datreeio/datree/cmd.CliVersion=${version}"
  ];

  tags = [ "main" ];

  postInstall = ''
    installShellCompletion \
      --cmd datree \
      --bash <($out/bin/datree completion bash) \
      --fish <($out/bin/datree completion fish) \
      --zsh <($out/bin/datree completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = datree;
    command = "datree version";
  };

  meta = with lib; {
    description = "CLI tool to ensure K8s manifests and Helm charts follow best practices";
    longDescription = ''
      Datree provides an E2E policy enforcement solution to run automatic checks
      for rule violations. Datree can be used on the command line, admission
      webhook, or even as a kubectl plugin to run policies against Kubernetes
      objects.
    '';
    homepage = "https://datree.io/";
    changelog = "https://github.com/datreeio/datree/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ azahi jceb ];
  };
}
