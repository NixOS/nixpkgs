{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "crd2pulumi";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "pulumi";
    repo = "crd2pulumi";
    rev = "v${version}";
    sha256 = "sha256-FkIHbZF1ylJI6meVnLKuSqVd8AYZnE/eixVZDvNRvs0=";
  };

  vendorSha256 = "sha256-kVD+TwU+tizNSXKIc7OqIJIA0nPOyfF9kVxBAYBzOKU=";

  ldflags = [ "-s" "-w" "-X github.com/pulumi/crd2pulumi/gen.Version=${src.rev}" ];

  subPackages = [ "." ];

  meta = with lib; {
    description = "Generate typed CustomResources from a Kubernetes CustomResourceDefinition";
    homepage = "https://github.com/pulumi/crd2pulumi";
    license = licenses.asl20;
    maintainers = with maintainers; [ flokli ];
  };
}
