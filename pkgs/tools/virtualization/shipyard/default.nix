{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "shipyard";
  version = "0.3.1";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "shipyard-run";
    repo = pname;
    sha256 = "sha256-zN9anlm+KbSbFKphC8mLaK+w8cOuOSKrVw5YGNCjEeA=";
  };
  vendorSha256 = "sha256-tTkPFftPDNXafIjAjNg6V6e/+2S/v5Do/YyAXPaGIqA=";

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
