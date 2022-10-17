{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "goreleaser";
  version = "1.11.5";

  src = fetchFromGitHub {
    owner = "goreleaser";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-RertNRBwrlodsjwv1NqNOR6ZDEMaRsHG1dVEu0Z501I=";
  };

  vendorSha256 = "sha256-d068X29Lh0l9S7HTmO75HcsV9ZdUsjp977Esxy7gzKI=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.builtBy=nixpkgs"
  ];

  # tests expect the source files to be a build repo
  doCheck = false;

  meta = with lib; {
    description = "Deliver Go binaries as fast and easily as possible";
    homepage = "https://goreleaser.com";
    maintainers = with maintainers; [ c0deaddict endocrimes sarcasticadmin techknowlogick ];
    license = licenses.mit;
  };
}
