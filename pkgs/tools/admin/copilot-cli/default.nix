{ lib, buildGoModule, fetchFromGitHub, installShellFiles, testers, copilot-cli }:

buildGoModule rec {
  pname = "copilot-cli";
  version = "1.19.0";

  src = fetchFromGitHub {
    owner = "aws";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-2zF/cBc6TjAcFAI3zJ0yBQrVWDK5nkxYYkb04bjSjgY=";
  };

  vendorSha256 = "sha256-1UFahXol1Lceccr/f24Mbhtk8bWyh4+Mb5VYZvF6VWs=";

  nativeBuildInputs = [ installShellFiles ];

  # follow LINKER_FLAGS in Makefile
  ldflags = [
    "-s"
    "-w"
    "-X github.com/aws/copilot-cli/internal/pkg/version.Version=${version}"
    "-X github.com/aws/copilot-cli/internal/pkg/cli.binaryS3BucketPath=https://ecs-cli-v2-release.s3.amazonaws.com"
  ];

  subPackages = [ "./cmd/copilot" ];

  postInstall = ''
    installShellCompletion --cmd copilot \
      --bash <($out/bin/copilot completion bash) \
      --fish <($out/bin/copilot completion fish) \
      --zsh <($out/bin/copilot completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = copilot-cli;
    command = "copilot version";
  };

  meta = with lib; {
    description = "Build, Release and Operate Containerized Applications on AWS.";
    homepage = "https://github.com/aws/copilot-cli";
    changelog = "https://github.com/aws/copilot-cli/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ jiegec ];
  };
}
