{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "crd2pulumi";
  version = "1.2.5";

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "crd2pulumi";
    rev = "v${version}";
    sha256 = "sha256-Km9zL9QQgQjmIaAILzJy8oSd9GyZn/MnmBYTRMFtXlE=";
  };

  vendorHash = "sha256-iWFZ20U4S2utIqhoXgLtT4pp5e9h8IpbveIKHPe0AAw=";

  ldflags = [ "-s" "-w" "-X github.com/pulumi/crd2pulumi/gen.Version=${src.rev}" ];

  subPackages = [ "." ];

  meta = with lib; {
    description = "Generate typed CustomResources from a Kubernetes CustomResourceDefinition";
    homepage = "https://github.com/pulumi/crd2pulumi";
    license = licenses.asl20;
    maintainers = with maintainers; [ flokli ];
  };
}
