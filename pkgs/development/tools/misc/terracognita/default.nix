{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "terracognita";
  version = "0.8.4";

  src = fetchFromGitHub {
    owner = "cycloidio";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-pPY8y+pQdk9/F7dnUBz/y4lvcR1k/EClywcZATArZVA=";
  };

  vendorHash = "sha256-ApnJH0uIClXbfXK+k4t9Tcayc2mfndoG9iMqZY3iWys=";

  doCheck = false;

  subPackages = [ "." ];

  ldflags = [ "-s" "-w" "-X github.com/cycloidio/terracognita/cmd.Version=${version}" ];

  meta = with lib; {
    description = "Reads from existing Cloud Providers (reverse Terraform) and generates your infrastructure as code on Terraform configuration";
    mainProgram = "terracognita";
    homepage = "https://github.com/cycloidio/terracognita";
    changelog = "https://github.com/cycloidio/terracognita/raw/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ ];
  };
}
