{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubedock";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "joyrex2001";
    repo = "kubedock";
    rev = version;
    hash = "sha256-xjt/RqvkOHTSTZwNgxmlUeYndPW9jwUE1knLyNXDxaE=";
  };

  vendorHash = "sha256-4X4v40c4J5SPwj53Zk+j+A9k0RkHGwqz128E+FnLr1c=";

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
