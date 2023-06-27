{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "jumppad";
  version = "0.5.27";

  src = fetchFromGitHub {
    owner = "jumppad-labs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-WTywuQ1sl5zKpwUYyHFb+eTRxlUUDWFIrmhsPDB+iyc=";
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
