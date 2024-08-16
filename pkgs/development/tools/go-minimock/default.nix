{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-minimock";
  version = "3.3.14";

  src = fetchFromGitHub {
    owner = "gojuno";
    repo = "minimock";
    rev = "v${version}";
    hash = "sha256-J4clMn65l7L+qSHbJBMDDRoEfgGHKllRu8nvTGlbgaw=";
  };

  ldflags = [
    "-s" "-w" "-X main.version=${version}"
  ];

  vendorHash = "sha256-60mOX0N8q9Q4Cb1G3hxQgykkDgvrVLYaZElptsW1PPI=";

  doCheck = true;

  subPackages = [ "cmd/minimock" "." ];

  meta = with lib; {
    homepage = "https://github.com/gojuno/minimock";
    description = "Golang mock generator from interfaces";
    license = licenses.mit;
    maintainers = with maintainers; [ svrana ];
    mainProgram = "minimock";
  };
}
