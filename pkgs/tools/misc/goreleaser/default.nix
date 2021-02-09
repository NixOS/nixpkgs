{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "goreleaser";
  version = "0.155.1";

  src = fetchFromGitHub {
    owner = "goreleaser";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-eVRsDyPlUvVhEnN8aJW8vPw4UqvK2/6pblgnwH2RhkY=";
  };

  vendorSha256 = "sha256-VFFwp+n13NL3YpzdWPVzgrH8d4BQHffwpRXvYn9MSaQ=";

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
