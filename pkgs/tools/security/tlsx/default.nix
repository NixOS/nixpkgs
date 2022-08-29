{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "tlsx";
  version = "0.0.6";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-0/J+2TDY63Zj40GzdL7M4ApJJ6xtqZWMIQnl3GSlvQA=";
  };

  vendorSha256 = "sha256-ERZ4mWmtOsW1nYUshSbCzhy+KcujviPtL4LS/soPrFQ=";

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
