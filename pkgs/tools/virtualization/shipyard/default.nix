{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "shipyard";
  version = "0.1.18";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "shipyard-run";
    repo = pname;
    sha256 = "sha256-ZrzW1sx0wCuaICONS3SR0VsqDj2ZUM53LaB5Wj1s9uc=";
  };
  vendorSha256 = "sha256-eeR316CKlAqWxlYcPZVlP260NR7WHfmCVE3PywMay/w=";

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
