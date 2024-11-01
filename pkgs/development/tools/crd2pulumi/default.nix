{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "crd2pulumi";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "crd2pulumi";
    rev = "v${version}";
    sha256 = "sha256-sXZ5iImN+AwAEV6Xur4EbDZhzQEYJFf9AgaBf1wQAIA=";
  };

  vendorHash = "sha256-4L1KfpZ+KICPko74x3STRQFtkcNVU/5KFGhKEJ64+Jk=";

  ldflags = [ "-s" "-w" "-X github.com/pulumi/crd2pulumi/gen.Version=${src.rev}" ];

  subPackages = [ "." ];

  meta = with lib; {
    description = "Generate typed CustomResources from a Kubernetes CustomResourceDefinition";
    mainProgram = "crd2pulumi";
    homepage = "https://github.com/pulumi/crd2pulumi";
    license = licenses.asl20;
    maintainers = with maintainers; [ flokli ];
  };
}
