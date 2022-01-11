{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pihole-exporter";
  version = "0.0.11";

  src = fetchFromGitHub {
    owner = "eko";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-SojEq6pedoq08wo/3zPHex7ex1QqSVIzZpBd49tLOjI=";
  };

  vendorSha256 = "sha256-LXgI9ioJgyhUiOCqRku0Q4enZF7q6MB0hYhPJlLusdc=";

  meta = with lib; {
    description = "Prometheus exporter for PI-Hole's Raspberry PI ad blocker";
    homepage = "https://github.com/eko/pihole-exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
