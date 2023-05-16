{ lib, buildGoModule, fetchFromGitHub, installShellFiles, testers, copilot-cli }:

buildGoModule rec {
  pname = "copilot-cli";
<<<<<<< HEAD
  version = "1.30.1";
=======
  version = "1.27.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "aws";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-ldSF+M6gYKJ6EDJ4jKpPS+XTyybynsRhibNtLG1+DlE=";
  };

  vendorHash = "sha256-/2uUiFL2wL+gAzqY2S3sqytPLKB5+QkYXCBNLqSJSWU=";
=======
    sha256 = "sha256-Py45QkivjwVNQqKX5/j4YUO+gpVYfXI7elD9YSlrmak=";
  };

  vendorHash = "sha256-ali7zvLLLB5kQCU9r2o/dO0g5CQxv/kVVz3iJ56fqYY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
