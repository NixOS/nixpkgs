{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pulumictl";
  version = "0.0.46";

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "pulumictl";
    rev = "v${version}";
    sha256 = "sha256-7A6dx/5091FIQ2AB6C+Z2CjhTBx2e6iB21Du2u9EiHY=";
  };

  vendorHash = "sha256-Wktr3TXSIIzbkiT3Gk5i4K58gahnxySi6ht30li+Z0o=";

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
