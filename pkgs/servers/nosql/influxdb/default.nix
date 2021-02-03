{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "influxdb";
  version = "1.8.4";

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-cL+QaUGMElYd6P+xXkQgRnL8BKo2C95bhCwy59kRnwo=";
  };

  vendorSha256 = "sha256-v4CEkhQiETeU6i186XIE/8z4T71gdKL+6W7sQ7/2RuI=";

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
