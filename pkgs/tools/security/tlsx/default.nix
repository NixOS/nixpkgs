{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "tlsx";
  version = "0.0.5";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-zUaCUi7U757A8OVQHQV2LPVqu4o73qrp2xGrH7u2viA=";
  };

  vendorSha256 = "sha256-+pSmErlxRyDH1drri294vE+hUmlmKgh3zrKpVJVC1do=";

  meta = with lib; {
    description = "TLS grabber focused on TLS based data collection";
    longDescription = ''
      A fast and configurable TLS grabber focused on TLS based data
      collection and analysis.
    '';
    homepage = "https://github.com/projectdiscovery/tlsx";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
