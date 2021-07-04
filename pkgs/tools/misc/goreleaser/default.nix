{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "goreleaser";
  version = "0.172.1";

  src = fetchFromGitHub {
    owner = "goreleaser";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-xTLNAcqvk5GDs9HsNvL+4SPeT8baFMg7J0yW+E8x+Gc=";
  };

  vendorSha256 = "sha256-Zd48I7e5zCbSXz5RVckMXQMpqvf6gAoajx5yLk2ODmU=";

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
