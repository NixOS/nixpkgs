{ lib
, mkPulumiPackage
}:
mkPulumiPackage rec {
  owner = "pulumi";
  repo = "pulumi-hcloud";
  version = "1.14.1";
  rev = "v${version}";
  hash = "sha256-nHqMqOVDGR+K8t6Mb2VbYzFw4747uV1/wtqqLWtrs8Y=";
  vendorHash = "sha256-o00vWpiXUfeAaPEwhWJz75yaKCxrEFrwP6T1Gy70suU=";
  cmdGen = "pulumi-tfgen-hcloud";
  cmdRes = "pulumi-resource-hcloud";
  extraLdflags = [
    "-X github.com/pulumi/${repo}/provider/pkg/version.Version=v${version}"
  ];
  __darwinAllowLocalNetworking = true;
  meta = with lib; {
    description = "A Hetzner Cloud Pulumi resource package, providing multi-language access to Hetzner Cloud";
    homepage = "https://github.com/pulumi/pulumi-hcloud";
    license = licenses.asl20;
    maintainers = with maintainers; [ veehaitch trundle ];
  };
}
