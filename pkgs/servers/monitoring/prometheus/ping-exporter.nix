{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ping-exporter";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "czerwonk";
    repo = "ping_exporter";
    rev = version;
    hash = "sha256-Jdo+6/e9gES8q4wTGRuy5HSj7VimOMZ9q3guKDcKJxg=";
  };

  vendorHash = "sha256-1oNbg6lu9xLJKeYOzK23HOTLJc3KWri7z4/2AZ7Hzms=";

  meta = with lib; {
    description = "Prometheus exporter for ICMP echo requests";
    mainProgram = "ping_exporter";
    homepage = "https://github.com/czerwonk/ping_exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ nudelsalat ];
  };
}
