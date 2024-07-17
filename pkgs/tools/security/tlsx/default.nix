{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "tlsx";
  version = "1.1.6";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "tlsx";
    rev = "refs/tags/v${version}";
    hash = "sha256-FF5/STjf8joyJM6qPds1wFeRfncSamy/wWfNRZcG5kc=";
  };

  vendorHash = "sha256-sJravmpvwOSZiVNWFUTLlTA4xk6drItDj4JzR8JNrOo=";

  ldflags = [
    "-s"
    "-w"
  ];

  # Tests require network access
  doCheck = false;

  meta = with lib; {
    description = "TLS grabber focused on TLS based data collection";
    longDescription = ''
      A fast and configurable TLS grabber focused on TLS based data
      collection and analysis.
    '';
    homepage = "https://github.com/projectdiscovery/tlsx";
    changelog = "https://github.com/projectdiscovery/tlsx/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
