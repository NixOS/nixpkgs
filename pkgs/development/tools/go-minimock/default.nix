{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "go-minimock";
  version = "3.3.9";

  src = fetchFromGitHub {
    owner = "gojuno";
    repo = "minimock";
    rev = "v${version}";
    sha256 = "sha256-J/nZJrq7CKF5dYj096svBZf9SaD9ehIk/I293y7IQXc=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  vendorHash = "sha256-O1Bp+zuSq3/UULpej4rXxeHcDiNAhECqj9Yh9aGeA0E=";

  doCheck = true;

  subPackages = [
    "cmd/minimock"
    "."
  ];

  meta = with lib; {
    homepage = "https://github.com/gojuno/minimock";
    description = "A golang mock generator from interfaces";
    license = licenses.mit;
    maintainers = with maintainers; [ svrana ];
    mainProgram = "minimock";
  };
}
