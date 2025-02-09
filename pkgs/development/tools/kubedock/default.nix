{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubedock";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "joyrex2001";
    repo = "kubedock";
    rev = version;
    hash = "sha256-UCoQm/lg8QRwsK2riJyHmCLg+Ash8Pg+6Va1RVemdt0=";
  };

  vendorHash = "sha256-mkzj+8c1MJgPHohSjSj7OW+xoYvI9Qoj3cXJ1iRDeWc=";

  # config.Build not defined as it would break r-ryantm
  ldflags = [
    "-s"
    "-w"
    "-X github.com/joyrex2001/kubedock/internal/config.Version=${version}"
  ];

  CGO_ENABLED = 0;

  meta = with lib; {
    description = "Minimal implementation of the Docker API that will orchestrate containers on a Kubernetes cluster";
    homepage = "https://github.com/joyrex2001/kubedock";
    license = licenses.mit;
    maintainers = with maintainers; [ mausch ];
    mainProgram = "kubedock";
  };
}
