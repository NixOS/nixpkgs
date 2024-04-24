{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "jumppad";
  version = "0.5.59";

  src = fetchFromGitHub {
    owner = "jumppad-labs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ObDbZ3g+BtH8JCqLIa+gR69GowZA8T9HMPuKNDgW3uA=";
  };
  vendorHash = "sha256-9DLDc6zI0BYd2AK9xwqFNJTFdKXagkdPwczLhCvud94=";

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
    mainProgram = "jumppad";
  };
}
