{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "influxdb";
  version = "1.8.2";

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = pname;
    rev = "v${version}";
    sha256 = "11zkia43i3in1xv84iz6rm9cfhf4k6nxn144m7dz7a7nv3chi20g";
  };

  vendorSha256 = "097x3z1fhdl5s3ni2qzbqxqr60l6lqcrbikq20fs052dp287q0sp";

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
