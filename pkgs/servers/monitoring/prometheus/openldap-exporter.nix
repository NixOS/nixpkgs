{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "openldap_exporter";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "tomcz";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-1u+89odwV/lz34wtrK91lET2bOqkH6kRA7JCjzsmiEg=";
  };

  vendorHash = null;

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
