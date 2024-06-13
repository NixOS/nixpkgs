{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-minimock";
  version = "3.3.12";

  src = fetchFromGitHub {
    owner = "gojuno";
    repo = "minimock";
    rev = "v${version}";
    hash = "sha256-9iokhXkwmISjg8pOy11bax0KEfro2lpGLI9fbz2tpiY=";
  };

  ldflags = [
    "-s" "-w" "-X main.version=${version}"
  ];

  vendorHash = "sha256-O1Bp+zuSq3/UULpej4rXxeHcDiNAhECqj9Yh9aGeA0E=";

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
