{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "pihole-exporter";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "eko";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ge4+sWQkJ2Zc7Y7+IYAq6OK6pYkaE3jjFo1rhTaDMu4=";
  };

  vendorHash = "sha256-4qbfXRXEViR/2fCmanlU88zvbJb5oppHWC7rVQaneLc=";

  meta = with lib; {
    description = "Prometheus exporter for PI-Hole's Raspberry PI ad blocker";
    mainProgram = "pihole-exporter";
    homepage = "https://github.com/eko/pihole-exporter";
    license = licenses.mit;
    maintainers = [ ];
  };
}
