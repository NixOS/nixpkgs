{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "tlsx";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-lS/D3p8Q6Zu3/XxwkC77fPS9cXVrUTkDPGd46Y+krbo=";
  };

  vendorHash = "sha256-aEsq9LwU/ZWvuZGGzZ4NEvMWFk1m/Sr9LOXiCA/X388=";

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
