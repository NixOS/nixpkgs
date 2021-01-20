{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "influxdb";
  version = "1.8.3";

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = pname;
    rev = "v${version}";
    sha256 = "1siv31gp7ypjphxjfv91sxzpz2rxk1nn2aj17pgk0cz7c8m59ic7";
  };

  vendorSha256 = "1pylw30dg6ljxm9ykmsqapg1vq71bj1ngdq4arvmmzcdhy1nhmh0";

  doCheck = false;

  buildFlagsArray = [ "-ldflags=-s -w -X main.version=${version}" ];

  excludedPackages = "test";

  meta = with lib; {
    description = "An open-source distributed time series database";
    license = licenses.mit;
    homepage = "https://influxdata.com/";
    maintainers = with maintainers; [ offline zimbatm ];
  };
}
