{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "goreleaser";
  version = "1.10.1";

  src = fetchFromGitHub {
    owner = "goreleaser";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-m42Gu1ExHs29cCTWo8V2q67bXBJ4kyn2ElR9kqVREjU=";
  };

  vendorSha256 = "sha256-/fZbKLmGhB8b33NqLkETtYa664ZEq+KY8GJ4pOZJhLo=";

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
