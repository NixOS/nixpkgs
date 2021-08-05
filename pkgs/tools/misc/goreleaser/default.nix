{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "goreleaser";
  version = "0.174.2";

  src = fetchFromGitHub {
    owner = "goreleaser";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-o/rDqYjOI+HxThQA7cflWUhCdsb6m4XOuzI753upmio=";
  };

  vendorSha256 = "sha256-P91wi2Fqo9+Yccqoqmsx0IbjSGUpiKIh7uOsgsR9c+0=";

  buildFlagsArray = [
    "-ldflags="
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
    maintainers = with maintainers; [ c0deaddict endocrimes sarcasticadmin ];
    license = licenses.mit;
  };
}
