{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "goreleaser";
  version = "1.11.2";

  src = fetchFromGitHub {
    owner = "goreleaser";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Qe2Q7cFu9G0Zj/mHTnxSq57OpeNMX3yZQp8VApVtZDc=";
  };

  vendorSha256 = "sha256-7xySEPmc24yOwUerGoARsKaGIYnIvaJFjcwNvbHG4Ls=";

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
