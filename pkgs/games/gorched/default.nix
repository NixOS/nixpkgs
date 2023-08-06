{ lib, stdenv, fetchFromGitHub, buildGoModule }:
buildGoModule rec {
  pname = "gorched";
  version = "1.6";

  src = fetchFromGitHub {
    owner = "zladovan";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-cT6wkWUlz3ixv7Mu5143I5NxjfwhKQ6bLwrW3BwTtTQ=";
  };

  vendorHash = "sha256-9fucarQKltIxV8j8L+yQ6Fa7IRIhoQCNxcG21KYOpuw=";

  meta = with lib; {
    description = "Gorched is terminal based game written in Go inspired by \"The Mother of all games\" Scorched Earth";
    homepage = "https://github.com/zladovan/gorched/";
    license = licenses.mit;
    maintainers = with maintainers; [ piturnah ];
  };
}
