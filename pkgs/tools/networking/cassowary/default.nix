{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "cassowary";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "rogerwelin";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-HRshuMnRPMzatOYYI//yEtjC46kORGXaAWJJjLHW2+k=";
  };

  vendorSha256 = "sha256-d8JPsHBGkZ/MeoHTCLxi6JeNomER/0veWjqmqGal8eE=";

  doCheck = false;

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  meta = with lib; {
    homepage = "https://github.com/rogerwelin/cassowary";
    description = "Modern cross-platform HTTP load-testing tool written in Go";
    license = licenses.mit;
    maintainers = with maintainers; [ hugoreeves ];
    platforms = platforms.unix;
  };
}
