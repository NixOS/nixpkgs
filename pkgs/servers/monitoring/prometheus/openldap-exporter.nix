{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "openldap_exporter";
  version = "2.3.2";

  src = fetchFromGitHub {
    owner = "tomcz";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Z7Num+vdTdxybN42119WAoWQYntQFNyR/SgBChpqZMk=";
  };

  vendorHash = "sha256-t119+SL8urK0mdTg6zYh1DigxpEVlpsEsza83XyrhMU=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/tomcz/openldap_exporter.tag=v${version}"
    "-X github.com/tomcz/openldap_exporter.commit=unknown"
  ];


  meta = with lib; {
    homepage = "https://github.com/tomcz/openldap_exporter";
    description = "Simple service that scrapes metrics from OpenLDAP and exports them via HTTP for Prometheus consumption";
    mainProgram = "openldap_exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ ma27 ];
  };
}
