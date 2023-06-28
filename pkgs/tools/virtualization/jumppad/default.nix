{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "jumppad";
  version = "0.5.28";

  src = fetchFromGitHub {
    owner = "jumppad-labs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-j1m95RiT4cymSK9PuJuNc+ixia4DNj+8lZ0KloB+kWo=";
  };
  vendorHash = "sha256-OtixGeQY1wPqs3WU6gKvrzEgxnMORxr4BWCpn/VYxRc=";

  ldflags = [
    "-s" "-w" "-X main.version=${version}"
  ];

  # Tests require a large variety of tools and resources to run including
  # Kubernetes, Docker, and GCC.
  doCheck = false;

  meta = with lib; {
    description = "A tool for building modern cloud native development environments";
    homepage = "https://jumppad.dev";
    license = licenses.mpl20;
    maintainers = with maintainers; [ cpcloud ];
  };
}
