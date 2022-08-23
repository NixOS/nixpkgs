{ lib, buildGoModule, fetchFromGitHub, nixosTests }:

buildGoModule rec {
  pname = "sql_exporter";
  version = "0.4.4";

  vendorSha256 = null;

  src = fetchFromGitHub {
    owner = "justwatchcom";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-A3hMSnfxiEgFYueARuldEHT/5ROCIwWjqQj2FdkVYqo=";
  };

  meta = with lib; {
    description = "Flexible SQL exporter for Prometheus";
    homepage = "https://github.com/justwatchcom/sql_exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ justinas ];
    platforms = platforms.unix;
  };
}
