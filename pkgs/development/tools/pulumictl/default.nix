{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pulumictl";
  version = "0.0.44";

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "pulumictl";
    rev = "v${version}";
    sha256 = "sha256-7Q+1shNZ18BZ6W6CslwUZhX0LtxPdTXOSNH5VhBHFxE=";
  };

  vendorHash = "sha256-XOgHvOaHExazQfsu1brYDq1o2fUh6dZeJlpVhCQX9ns=";

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
