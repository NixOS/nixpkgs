{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "openldap_exporter";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "tomcz";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ok2fTYz1oQiNdTPsssPb/VuFqny1i8nKTngSpKgCpC4=";
  };

  vendorSha256 = null;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/tomcz/openldap_exporter.tag=v${version}"
    "-X github.com/tomcz/openldap_exporter.commit=unknown"
  ];


  meta = with lib; {
    homepage = "https://github.com/tomcz/openldap_exporter";
    description = "Simple service that scrapes metrics from OpenLDAP and exports them via HTTP for Prometheus consumption";
    license = licenses.mit;
    maintainers = with maintainers; [ ma27 ];
  };
}
