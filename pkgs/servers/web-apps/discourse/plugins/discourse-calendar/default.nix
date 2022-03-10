{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-calendar";
  bundlerEnvArgs.gemdir = ./.;
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-calendar";
    rev = "765d16242ffeb4324c3269393d3fa81e9b751d4f";
    sha256 = "sha256-YYxspW0DX0DUBwPOcvX2pLJYmyK4b56LdjL6avLKzRs=";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-calendar";
    maintainers = with maintainers; [ ryantm ];
    license = licenses.mit;
    description = "Adds the ability to create a dynamic calendar in the first post of a topic";
  };
}
