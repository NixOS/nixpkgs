{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "crd2pulumi";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "crd2pulumi";
    rev = "v${version}";
    sha256 = "sha256-UBfb6PI+Ivk6JxSBIHw4tN09BHN1J+un04mnR3ByDfc=";
  };

  vendorHash = "sha256-Fs43ITqfZYEcuRzm5bTTgmG/tWGIX9k8gdYBHmO4tMQ=";

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
