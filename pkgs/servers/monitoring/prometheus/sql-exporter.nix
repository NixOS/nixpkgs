{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "sql_exporter";
  version = "0.4.2";

  vendorSha256 = null;

  src = fetchFromGitHub {
    owner = "justwatchcom";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Ujon6TLniQrYRxJe4+ZTu4/dI2K94r9M/lBmMizDZrA=";
  };

  meta = with lib; {
    description = "Flexible SQL exporter for Prometheus";
    homepage = "https://github.com/justwatchcom/sql_exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ justinas ];
    platforms = platforms.unix;
  };
}
