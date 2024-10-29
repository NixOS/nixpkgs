{ lib
, mkPulumiPackage
}:
mkPulumiPackage rec {
  owner = "pulumi";
  repo = "pulumi-random";
  version = "4.16.7";
  rev = "v${version}";
  hash = "sha256-Ef4GRbbGHe+Ni8ksHnV3oCqOw94n5XxHgvfefNpmAm0=";
  vendorHash = "sha256-O0Edcdw+Auxs+DO9ktESgA4MAnoRrsUDNW6S5QIRilc=";
  cmdGen = "pulumi-tfgen-random";
  cmdRes = "pulumi-resource-random";
  extraLdflags = [
    "-X github.com/pulumi/${repo}/provider/v4/pkg/version.Version=v${version}"
  ];
  __darwinAllowLocalNetworking = true;
  meta = with lib; {
    description = "Pulumi provider that safely enables randomness for resources";
    mainProgram = "pulumi-resource-random";
    homepage = "https://github.com/pulumi/pulumi-random";
    license = licenses.asl20;
    maintainers = with maintainers; [ veehaitch trundle ];
  };
}
