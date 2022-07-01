{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "influxdb";
  version = "1.8.10";

  src = fetchFromGitHub {
    owner = "influxdata";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-PErAxRpSi1Kk6IpEAhsUSxCGYeY4p6bbhwLdbRB0M00=";
  };

  vendorSha256 = "sha256-jgAbEWXL1LYRN7ud9ij0Z1KBGHPZ0sRq78tsK92ob8k=";

  doCheck = false;

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  excludedPackages = "test";

  meta = with lib; {
    description = "An open-source distributed time series database";
    license = licenses.mit;
    homepage = "https://influxdata.com/";
    maintainers = with maintainers; [ offline zimbatm ];
  };
}
