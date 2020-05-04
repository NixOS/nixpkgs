{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "cassowary";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "rogerwelin";
    repo = pname;
    rev = "v${version}";
    sha256 = "0p5vcs25h5nj36dm9yjmdjymcq0zldm3zlqfppxcjx862h48k8zj";
  };

  modSha256 = "1iylnnmj5slji89pkb3shp4xqar1zbpl7bzwddbzpp8y52fmsv1c";

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  meta = with lib; {
    homepage = "https://github.com/rogerwelin/cassowary";
    description = "Modern cross-platform HTTP load-testing tool written in Go";
    license = licenses.mit;
    maintainers = with maintainers; [ hugoreeves ];
    platforms = platforms.unix;
  };
}
