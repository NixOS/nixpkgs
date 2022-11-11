{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "scaleway-cli";
  version = "2.6.2";

  src = fetchFromGitHub {
    owner = "scaleway";
    repo = "scaleway-cli";
    rev = "v${version}";
    sha256 = "sha256-WEEmU0YslQcjleM6jFLXNxogkXlRAUjkj0q+saugPYA=";
  };

  vendorSha256 = "sha256-1YXw6b8xUa2yEfMURetImg2TnFTDUsiQi441pX/O57M=";

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
