{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "goreleaser";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "goreleaser";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-R20mzPpbFDUw/wrif3ZJCt2wgmV+yqSkGaxyuw/9z0E=";
  };

  vendorSha256 = "sha256-+Rj2hb9Sul5ntVGfuWf7JibKdG03zALiMWaaNTJFC8k=";

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
