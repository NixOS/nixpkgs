{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pgmetrics";
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "rapidloop";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-tEPn+/xTDBFWf3SH/+5R38zWGAmMCHcFw/JvuvG2Jvs=";
  };

  vendorHash = "sha256-jRgOIhRB5F/rbfNniXoOllvDqoHP8nkVwmEPSreHYXg=";

  doCheck = false;

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  meta = with lib; {
    homepage = "https://pgmetrics.io/";
    description = "Collect and display information and stats from a running PostgreSQL server";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
