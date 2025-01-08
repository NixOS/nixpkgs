{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "pihole-exporter";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "eko";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ZHeAp2++faqoxt+2uvtea2+xPST2sonuBJAhI6GZg1Y=";
  };

  vendorHash = "sha256-Wn4W7e8v/njvODA0znqtZsMRfcH6L6r5biAOwfyKUAU=";

  meta = with lib; {
    description = "Prometheus exporter for PI-Hole's Raspberry PI ad blocker";
    mainProgram = "pihole-exporter";
    homepage = "https://github.com/eko/pihole-exporter";
    license = licenses.mit;
    maintainers = [ ];
  };
}
