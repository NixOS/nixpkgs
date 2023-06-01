{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "shipyard";
  version = "0.5.2";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "shipyard-run";
    repo = pname;
    sha256 = "sha256-Fd0R067YGdigG9SyWjXQYyQEnJM7Oug7Qkb0v+zK09g=";
  };
  vendorHash = "sha256-aE58XYgEWdPtq+DZKtn8Jbw2YIiiJSPutmVEOsG7urk=";

  ldflags = [
    "-s" "-w" "-X main.version=${version}"
  ];

  # Tests require a large variety of tools and resources to run including
  # Kubernetes, Docker, and GCC.
  doCheck = false;

  meta = with lib; {
    description = "Shipyard is a tool for building modern cloud native development environments";
    homepage = "https://shipyard.run";
    license = licenses.mpl20;
    maintainers = with maintainers; [ cpcloud ];
  };
}
