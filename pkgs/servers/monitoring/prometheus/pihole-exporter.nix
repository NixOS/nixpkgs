{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "pihole-exporter";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "eko";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-T96sNzQHPWM30uzLH3ffH7pKFP3z8DV/e57+TlFuG2Q=";
  };

  vendorHash = "sha256-/+YHIpaBd9YfmX04CT2ohVpQc6iLFIFLvcIwGtPbc+s=";

  meta = with lib; {
    description = "Prometheus exporter for PI-Hole's Raspberry PI ad blocker";
    mainProgram = "pihole-exporter";
    homepage = "https://github.com/eko/pihole-exporter";
    license = licenses.mit;
    maintainers = [ ];
  };
}
