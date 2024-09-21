{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "tlsx";
  version = "1.1.7";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = "tlsx";
    rev = "refs/tags/v${version}";
    hash = "sha256-vCB1sUT5auZmIg3lHFdV905wDfay5R8v+5lEKIuVzEQ=";
  };

  vendorHash = "sha256-Tgvs5BUuRTGSU05O+8SSvHvReACqIXqt9MEJWB7O8p4=";

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
