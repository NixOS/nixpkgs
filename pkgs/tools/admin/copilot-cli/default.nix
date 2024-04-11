{ lib, buildGoModule, fetchFromGitHub, installShellFiles, testers, copilot-cli }:

buildGoModule rec {
  pname = "copilot-cli";
  version = "1.33.2";

  src = fetchFromGitHub {
    owner = "aws";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-+1ri9l6ngNIMFYg+n0wDluqZ6/Zl3it4yPOBglk/0JU=";
  };

  vendorHash = "sha256-HoiBg32L+aRsdDXFOvwZFURV2RttLIGuOOjB8lcYGXU=";

  nativeBuildInputs = [ installShellFiles ];

  # follow LINKER_FLAGS in Makefile
  ldflags = [
    "-s"
    "-w"
    "-X github.com/aws/copilot-cli/internal/pkg/version.Version=v${version}"
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
    version = "v${version}";
  };

  meta = with lib; {
    description = "Build, Release and Operate Containerized Applications on AWS";
    homepage = "https://github.com/aws/copilot-cli";
    changelog = "https://github.com/aws/copilot-cli/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ jiegec ];
    mainProgram = "copilot";
  };
}
