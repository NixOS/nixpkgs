{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pihole-exporter";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "eko";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-JxznxE4Pq1fhlt3l1jbGWD5eUg5VF0GmewkuSYECG0Y=";
  };

  vendorSha256 = "sha256-jfpM192LtFGVgsVv+F+P8avTGD5c8I+7JFsn4oVoqr0=";

  meta = with lib; {
    description = "Prometheus exporter for PI-Hole's Raspberry PI ad blocker";
    homepage = "https://github.com/eko/pihole-exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
