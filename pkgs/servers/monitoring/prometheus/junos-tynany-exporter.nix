{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "junos-tynany-exporter";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "tynany";
    repo = "junos_exporter";
    rev = "v${version}";
    hash = "sha256-UiewIXNdGxvQ8U3GU50gitr//qoxc4tZwU7yMLIHXrU=";
  };

  vendorHash = null;

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Prometheus Exporter for Junos Devices";
    homepage = "https://github.com/tynany/junos_exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ janik ];
  };
}
