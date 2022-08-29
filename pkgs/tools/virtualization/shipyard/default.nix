{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "shipyard";
  version = "0.4.10";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "shipyard-run";
    repo = pname;
    sha256 = "sha256-3l/lvPSoO4CXMfEDhzCqHT0aOkQLPuvoXg8j/kZdUfU=";
  };
  vendorSha256 = "sha256-ATXM3+mi/R+/jS6Ds89J75nDVnc3d8iOGhjD3KQZkkA=";

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
