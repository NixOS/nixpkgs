{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pulumictl";
  version = "0.0.29";

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "pulumictl";
    rev = "v${version}";
    sha256 = "sha256-2jTxtgEg+x/NY/LTWT5+9K9bilOw2bLTUIctjd+qwLE=";
  };

  vendorSha256 = "sha256-xalfnLc6bPBvm2B42+FzpgrOH541HMWmNHChveI792s=";

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
