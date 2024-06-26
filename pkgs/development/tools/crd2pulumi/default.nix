{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "crd2pulumi";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "crd2pulumi";
    rev = "v${version}";
    sha256 = "sha256-PfgFDYZS5zKywQH6f5L8mFmEagxcEQ74Ht7D22hSYHY=";
  };

  vendorHash = "sha256-k6YJhYY2P/D8Vbsp5PExKrcGXBv2GsIkqb3m6KeYm6g=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/pulumi/crd2pulumi/gen.Version=${src.rev}"
  ];

  subPackages = [ "." ];

  meta = with lib; {
    description = "Generate typed CustomResources from a Kubernetes CustomResourceDefinition";
    mainProgram = "crd2pulumi";
    homepage = "https://github.com/pulumi/crd2pulumi";
    license = licenses.asl20;
    maintainers = with maintainers; [ flokli ];
  };
}
