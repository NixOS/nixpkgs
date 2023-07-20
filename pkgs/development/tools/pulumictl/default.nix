{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pulumictl";
  version = "0.0.43";

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "pulumictl";
    rev = "v${version}";
    sha256 = "sha256-iz0ahzR0+CpNZSLbR9zyIRS5k3y1GYbh7BPif9I6n4k=";
  };

  vendorHash = "sha256-WzfTS68YIpoZYbm6i0USxXyEyR4px+hrNRbsCTXdJsk=";

  ldflags = [
    "-s" "-w" "-X=github.com/pulumi/pulumictl/pkg/version.Version=${src.rev}"
  ];

  subPackages = [ "cmd/pulumictl" ];

  meta = with lib; {
    description = "Swiss Army Knife for Pulumi Development";
    homepage = "https://github.com/pulumi/pulumictl";
    license = licenses.asl20;
    maintainers = with maintainers; [ vincentbernat ];
  };
}
