{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "ctlptl";
  version = "0.8.7";

  src = fetchFromGitHub {
    owner = "tilt-dev";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-cSgsEjOnaFUuf9Vf6UOCC7LsmVg47wEQKU0LxpngLYc=";
  };

  vendorSha256 = "sha256-M9B/rfMBjYJb9szmYPVZqURlcv62qHOLJ3ka0v++z0s=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  meta = with lib; {
    description = "CLI for declaratively setting up local Kubernetes clusters";
    homepage = "https://github.com/tilt-dev/ctlptl";
    license = licenses.asl20;
    maintainers = with maintainers; [ svrana ];
  };
}
