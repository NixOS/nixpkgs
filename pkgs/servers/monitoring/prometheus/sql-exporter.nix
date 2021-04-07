{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "sql_exporter";
  version = "0.4.0";

  vendorSha256 = null;

  src = fetchFromGitHub {
    owner = "justwatchcom";
    repo = pname;
    rev = "v${version}";
    sha256 = "0dxzcd3b430xby741fdc85k4d2380jrh34xxskmdzxbf2kqdc5k8";
  };

  meta = with lib; {
    description = "Flexible SQL exporter for Prometheus";
    homepage = "https://github.com/justwatchcom/sql_exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ justinas ];
    platforms = platforms.unix;
  };
}
