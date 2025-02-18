{
  lib,
  mkPulumiPackage,
}:
mkPulumiPackage rec {
  owner = "pulumi";
  repo = "pulumi-aws";
  version = "6.55.0";
  rev = "v${version}";
  hash = "sha256-v/ERgq7ZipUZcJCgWpTn88ZusmzZ1EWYETm9dZRg6Io=";
  vendorHash = "sha256-xNVkkhBnprJpzgt5S/1b1PAOAo1B/52OvCgvCSJ9+M0=";
  fetchSubmodules = true;
  cmdGen = "pulumi-tfgen-aws";
  cmdRes = "pulumi-resource-aws";
  extraLdflags = [
    "-X=github.com/pulumi/${repo}/provider/v6/pkg/version.Version=v${version}"
  ];
  preBuild = ''
    PULUMI_AWS_MINIMAL_SCHEMA=true VERSION=v${version} go generate cmd/${cmdRes}/main.go
  '';
  __darwinAllowLocalNetworking = true;
  meta = with lib; {
    description = "An Amazon Web Services (AWS) Pulumi resource package, providing multi-language access to AWS";
    homepage = "https://github.com/pulumi/pulumi-aws";
    license = licenses.asl20;
    maintainers = with maintainers; [ tie ];
    mainProgram = "pulumi-resource-aws";
  };
}
