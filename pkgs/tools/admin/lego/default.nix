{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "lego";
  version = "3.7.0";

  src = fetchFromGitHub {
    owner = "go-acme";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-hjH1TBw6GHYNI9JSBOzdyEtJmp8NhlwNYydGZwsjAg0=";
  };

  modSha256 = "sha256-+PJRaDdZqVO6D9SXojlr8JXn++pL18HOHFdaiUEalw8=";
  subPackages = [ "cmd/lego" ];

  buildFlagsArray = [
    "-ldflags=-X main.version=${version}"
  ];

  meta = with lib; {
    description = "Let's Encrypt client and ACME library written in Go";
    license = licenses.mit;
    homepage = "https://go-acme.github.io/lego/";
    maintainers = teams.acme.members;
  };
}
