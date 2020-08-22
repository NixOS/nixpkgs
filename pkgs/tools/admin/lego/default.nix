{ lib, fetchFromGitHub, buildGoModule }:

buildGoModule rec {
  pname = "lego";
  version = "3.8.0";

  src = fetchFromGitHub {
    owner = "go-acme";
    repo = pname;
    rev = "v${version}";
    sha256 = "02p7zlrz8fp5bsvhk4jrx5x3gxnl00friay1jihlzyk3s400n9jb";
  };

  vendorSha256 = "0jh7qi422i2114198fain9nwwf8yd8vna0p3g0hvginh59svyagc";

  doCheck = false;

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
