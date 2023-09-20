{ lib
, mkPulumiPackage
}:
mkPulumiPackage rec {
  owner = "pulumi";
  repo = "pulumi-github";
  version = "5.21.0";
  rev = "v${version}";
  hash = "sha256-ZgGyr0bBupcI5Q9Ih4NYhE1axLaTgFiQ+cCZ9lIc0/w=";
  vendorHash = "sha256-GfLhfgyVJPwjpjvF9mirxhlnjY0QyxSl/AM6dYgu/HA";
  cmdGen = "pulumi-tfgen-github";
  cmdRes = "pulumi-resource-github";
  extraLdflags = [
    "-X github.com/pulumi/${repo}/provider/v5/pkg/version.Version=v${version}"
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "A Pulumi package to facilitate interacting with GitHub";
    homepage = "https://github.com/pulumi/pulumi-github";
    license = licenses.asl20;
    maintainers = with maintainers; [ trundle veehaitch ];
  };
}
