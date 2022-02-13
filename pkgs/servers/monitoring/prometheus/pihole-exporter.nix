{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pihole-exporter";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "eko";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-MkWGJks0Ol4bEbD+k72zEFP09f5eSN7y9Jhhzpu/Uyc=";
  };

  vendorSha256 = "sha256-+zI0cGzTs4+Fco/qh8bhWLkfgxpEdcX4BOIVdV1f8ew=";

  meta = with lib; {
    description = "Prometheus exporter for PI-Hole's Raspberry PI ad blocker";
    homepage = "https://github.com/eko/pihole-exporter";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
