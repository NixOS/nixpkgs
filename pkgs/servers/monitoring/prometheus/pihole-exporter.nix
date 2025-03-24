{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "pihole-exporter";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "eko";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Sum27hjs0Jvi1UWGeQcR8z9zmZ/I40uBFpKeHgHfFrA=";
  };

  vendorHash = "sha256-7f/upTF3/w40wWGdcw0h3kOPlo8ZeyRna6FapnF2X0s=";

  meta = with lib; {
    description = "Prometheus exporter for PI-Hole's Raspberry PI ad blocker";
    mainProgram = "pihole-exporter";
    homepage = "https://github.com/eko/pihole-exporter";
    license = licenses.mit;
    maintainers = [ ];
  };
}
