{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "scaleway-cli";
  version = "2.16.1";

  src = fetchFromGitHub {
    owner = "scaleway";
    repo = "scaleway-cli";
    rev = "v${version}";
    sha256 = "sha256-bKqlI2t7fBkKxtQPaboDsov206eD9bWpxAugaUFBIRc=";
  };

  vendorHash = "sha256-Y28j4vgGZ23yV2SqIsfhtc/Kj4g+Lgju/t2w+3xarnE=";

  ldflags = [
    "-w"
    "-extldflags"
    "-static"
    "-X main.Version=${version}"
    "-X main.GitCommit=ref/tags/${version}"
    "-X main.GitBranch=HEAD"
    "-X main.BuildDate=unknown"
  ];

  # some tests require network access to scaleway's API, failing when sandboxed
  doCheck = false;

  meta = with lib; {
    description = "Interact with Scaleway API from the command line";
    homepage = "https://github.com/scaleway/scaleway-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ nickhu techknowlogick ];
  };
}
