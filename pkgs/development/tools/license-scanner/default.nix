{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "license-scanner";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "CycloneDX";
    repo = "license-scanner";
    rev = "refs/tags/v${version}";
    hash = "sha256-X7omSecbb85dtxPJtgdjLLgJQRJ7dh12DGwzIG0tYcE=";
  };

  vendorHash = "sha256-7xa2tdCDCXkOZCLL8YPtO7i1VqD61Mow7un0690I8mM=";

  meta = with lib; {
    description = "Utility that provides an API and CLI to identify licenses and legal terms";
    homepage = "https://github.com/CycloneDX/license-scanner";
    changelog = "https://github.com/CycloneDX/license-scanner/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
