{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "tlsx";
  version = "1.0.8";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-qwLYRRta1ElnhwWWBMAv6iXWKfic4vR9fuULATWJF3I=";
  };

  vendorHash = "sha256-0Nyt/XY4gWL4yoS+Zq3hZUzjf3SySLmxrxfFryCTbTc=";

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
