{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "jumppad";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "jumppad-labs";
    repo = "jumppad";
    rev = version;
    hash = "sha256-f9V3dws4zvjh3H61FWNv9r/G9EplWR0aA2af2EdjhBs=";
  };
  vendorHash = "sha256-S4SyuidH8sxJbuG7yHgSP/iHcuP1h5EHaW8X6gG4GNw=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-X main.version=${version}"
  ];

  # Tests require a large variety of tools and resources to run including
  # Kubernetes, Docker, and GCC.
  doCheck = false;

  meta = with lib; {
    description = "Tool for building modern cloud native development environments";
    homepage = "https://jumppad.dev";
    license = licenses.mpl20;
    maintainers = with maintainers; [ cpcloud ];
    mainProgram = "jumppad";
  };
}
