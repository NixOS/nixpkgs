{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tf2pulumi";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "tf2pulumi";
    rev = "v${version}";
    sha256 = "sha256-4sEsWMkGRpB3gMGUOPh7n/nNwEp+ErKQK0qcT5ImaZ4=";
  };

  vendorSha256 = "sha256-wsgNrDnFXbpanEULEjf6OxOeMYmWzjE7vpVUB/UFNp8=";

  ldflags = [
    "-s" "-w" "-X=github.com/pulumi/tf2pulumi/version.Version=${src.rev}"
  ];

  subPackages = [ "." ];

  meta = with lib; {
    description = "Convert Terraform projects to Pulumi TypeScript programs";
    homepage = "https://www.pulumi.com/tf2pulumi/";
    license = licenses.asl20;
    maintainers = with maintainers; [ mausch ];
  };
}
