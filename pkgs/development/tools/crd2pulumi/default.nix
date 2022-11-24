{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "crd2pulumi";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "crd2pulumi";
    rev = "v${version}";
    sha256 = "sha256-0+83etSRk7nAaIrA5qu+BL7BfzBkjO7gsExQJ255ZOY=";
  };

  vendorSha256 = "sha256-QnmqhXfE/999i+idAZbREMzNi62164uq5nGKb1nauwk=";

  ldflags = [ "-s" "-w" "-X github.com/pulumi/crd2pulumi/gen.Version=${src.rev}" ];

  subPackages = [ "." ];

  meta = with lib; {
    description = "Generate typed CustomResources from a Kubernetes CustomResourceDefinition";
    homepage = "https://github.com/pulumi/crd2pulumi";
    license = licenses.asl20;
    maintainers = with maintainers; [ flokli ];
  };
}
