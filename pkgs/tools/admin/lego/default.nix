{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "lego";
  version = "3.5.0";

  src = fetchFromGitHub {
    owner = "go-acme";
    repo = pname;
    rev = "v${version}";
    sha256 = "08mh2q426gmhcaz578lw08jbxfqb7qm37cd00ap937dymi1zs9qw";
  };

  modSha256 = "10n8pcbmzlnk63gzsjb1xnmjwxfhxsqx8ffpcbwdzq9fc5yvjiii";
  subPackages = [ "cmd/lego" ];

  buildFlagsArray = [
    "-ldflags=-X main.version=${version}"
  ];

  meta = with lib; {
    description = "Let's Encrypt client and ACME library written in Go";
    license = licenses.mit;
    homepage = "https://go-acme.github.io/lego/";
    maintainers = with maintainers; [ andrew-d ];
  };
}
