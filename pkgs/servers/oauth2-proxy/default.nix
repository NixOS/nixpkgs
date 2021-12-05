{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "oauth2-proxy";
  version = "7.2.0";

  src = fetchFromGitHub {
    repo = pname;
    owner = "oauth2-proxy";
    sha256 = "1awqada8vwyz3aj1ip9jgmf84hb60jai16in6yhn4b42x9qj8m08";
    rev = "v${version}";
  };

  vendorSha256 = "1k6ak175z1qikicmqb6c8sc3dnwghpy9rv7ayl8mpq50y3ighwqi";

  # Taken from https://github.com/oauth2-proxy/oauth2-proxy/blob/master/Makefile
  ldflags = [ "-X main.VERSION=${version}" ];

  meta = with lib; {
    description =
      "A reverse proxy that provides authentication with Google, Github, or other providers";
    homepage = "https://github.com/oauth2-proxy/oauth2-proxy/";
    license = licenses.mit;
    maintainers = teams.serokell.members;
  };
}
