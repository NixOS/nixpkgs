{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "goreleaser";
  version = "0.173.1";

  src = fetchFromGitHub {
    owner = "goreleaser";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-v3Sln1qtYDdWCWJSKErxUoPAUzwWrTYM0j5X+mz+1xo=";
  };

  vendorSha256 = "sha256-yX8Ffdzq22JHA2owtHurH8AEgqPgPjz+N06oD5ZiZmM=";

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
