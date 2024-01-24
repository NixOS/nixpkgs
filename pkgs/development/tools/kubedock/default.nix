{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "kubedock";
  version = "0.15.2";

  src = fetchFromGitHub {
    owner = "joyrex2001";
    repo = "kubedock";
    rev = version;
    hash = "sha256-EewvlH+Coz/78AfZfj230BNzuPsKvB7pnV0sJtvYGnc=";
  };

  vendorHash = "sha256-rkn6JzPB1UNpaCon6LyYNUAsV88t3xbppDrtBwjBEHk=";

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
