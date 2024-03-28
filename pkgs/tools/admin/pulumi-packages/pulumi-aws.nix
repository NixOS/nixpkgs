{ lib
, mkPulumiPackage
}:
mkPulumiPackage rec {
  owner = "pulumi";
  repo = "pulumi-aws";
  version = "6.2.1";
  rev = "v${version}";
  hash = "sha256-ETTeJBqUnqbc5dhCmf/cGJl+9x6c2vbKEQWOfkiJ+kI=";
  vendorHash = "sha256-FDFQywWugEyh9fK1G+YfIw5bms4l5zLuqCY3yJPAQZY=";
  fetchSubmodules = true;
  cmdGen = "pulumi-tfgen-aws";
  cmdRes = "pulumi-resource-aws";
  extraLdflags = [
    "-X github.com/pulumi/${repo}/provider/v6/pkg/version.Version=v${version}"
  ];
  __darwinAllowLocalNetworking = true;
  meta = with lib; {
    description = "An Amazon Web Services (AWS) Pulumi resource package, providing multi-language access to AWS";
    homepage = "https://github.com/pulumi/pulumi-aws";
    license = licenses.asl20;
    maintainers = with maintainers; [ veehaitch trundle ];
    mainProgram = "pulumi-resource-aws";
  };
}
