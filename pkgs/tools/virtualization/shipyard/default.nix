{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "shipyard";
  version = "0.2.9";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "shipyard-run";
    repo = pname;
    sha256 = "sha256-S2nH1E20frsJzW2RCn+eJ9ylVdhVbo4wesNwlQll9S4=";
  };
  vendorSha256 = "sha256-rglpY7A0S56slL+mXFRgaZwS0bF1b9zxxmNYiX6TJzs=";

  buildFlagsArray = [
    "-ldflags=-s -w -X main.version=${version}"
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
