{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "copilot-cli";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "copilot-cli";
    rev = "v${version}";
    sha256 = "1r84sim4fy58sdkpi47a8k7zx9ybxi84bdsa0kdb60ir4dig2ga6";
  };

  vendorSha256 = "1px4z747bnv1igxq6y4hvnfnn9y3r6hnb0q2sfk21mg8w0aj249c";

  buildPhase = ''
    make VERSION=${src.rev} compile-local
  '';

  installPhase = ''
    install -Dm 555 ./bin/local/copilot $out/bin/copilot
  '';

  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
    $out/bin/copilot completion bash > copilot.bash
    $out/bin/copilot completion zsh > copilot.zsh
    installShellCompletion copilot.{bash,zsh}
  '';

  meta = with lib; {
    description = "A CLI for deploying containerized applications on Amazon ECS and AWS Fargate";
    homepage = "https://aws.github.io/copilot-cli";
    license = licenses.asl20;
    maintainers = with maintainers; [ dbirks ];
  };
}
