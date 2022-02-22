{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "datree";
  version = "0.15.22";

  src = fetchFromGitHub {
    owner = "datreeio";
    repo = "datree";
    rev = version;
    hash = "sha256-g5u2QQtVmNp01KtUKwC8uoEIuoBDLHsOlRz1Mv0n/y8=";
  };

  vendorSha256 = "sha256-O1ENQCCc0iSAMfZWczoiGMCSx4tu/R/CPsztPx7APuA=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/datreeio/datree/cmd.CliVersion=${version}"
  ];

  doCheck = true;

  meta = with lib; {
    description = "CLI tool to ensure K8s manifests and Helm charts follow best practices as well as your organization’s policies";
    homepage = "https://datree.io/";
    license = [ licenses.asl20 ];
    maintainers = [ maintainers.jceb ];
  };
}
