{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "terracognita";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "cycloidio";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ipPJMh88R9Ddo1QzN+No9H2bBsLSPARUI2HRaYvK6jc=";
  };

  vendorHash = "sha256-7fGqChud9dcgA9BXyJysUgvvG7zI+ByA0oFlSMd+rps=";

  doCheck = false;

  subPackages = [ "." ];

  ldflags = [ "-s" "-w" "-X github.com/cycloidio/terracognita/cmd.Version=${version}" ];

  meta = with lib; {
    description = "Reads from existing Cloud Providers (reverse Terraform) and generates your infrastructure as code on Terraform configuration";
    homepage = "https://github.com/cycloidio/terracognita";
    changelog = "https://github.com/cycloidio/terracognita/raw/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
