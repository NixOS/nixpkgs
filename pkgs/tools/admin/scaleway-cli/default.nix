{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "scaleway-cli";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "scaleway";
    repo = "scaleway-cli";
    rev = "v${version}";
    sha256 = "sha256-a8imZN3APQEb9ntQOzOKGBEiPKmb5ZYC9ZKnOuLiElc=";
  };

  vendorSha256 = "sha256-aaYS0WqNa8997kdV38blUsYovtUHHtEUXCTG9vwv2ko=";

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
    maintainers = with maintainers; [ nickhu ];
  };
}
