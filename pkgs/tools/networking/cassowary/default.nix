{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "cassowary";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "rogerwelin";
    repo = pname;
    rev = "v${version}";
    sha256 = "06yq3qrl6dzy93l18r0xbr3fr3v6zakva806svp6bw3qgpn7c0h2";
  };

  vendorSha256 = "1r5zgr971sakqnvn56h92bbndhway4vn080fhjcz6zjgcmlcdb24";

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  meta = with lib; {
    homepage = "https://github.com/rogerwelin/cassowary";
    description = "Modern cross-platform HTTP load-testing tool written in Go";
    license = licenses.mit;
    maintainers = with maintainers; [ hugoreeves ];
    platforms = platforms.unix;
  };
}