{ buildGoPackage, lib, fetchFromGitHub }:

buildGoPackage rec {
  pname = "openldap_exporter";
  version = "2.1.4";

  src = fetchFromGitHub {
    owner = "tomcz";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-G4bTYFm1Zh+7gfSIZnfrPyQ15967ebEzl33pgZu23D4=";
  };

  ldflags = [
    "-s" "-w"
    "-X github.com/tomcz/openldap_exporter.tag=v${version}"
    "-X github.com/tomcz/openldap_exporter.commit=unknown"
  ];

  goPackagePath = "github.com/tomcz/openldap_exporter";

  meta = with lib; {
    homepage = "https://github.com/tomcz/openldap_exporter";
    description = " Simple service that scrapes metrics from OpenLDAP and exports them via HTTP for Prometheus consumption";
    license = licenses.mit;
    maintainers = with maintainers; [ ma27 ];
  };
}
