{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "tlsx";
  version = "0.0.7";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-tyZDmtqQLTV06mLo1lg/qWRjvxvgVvGpoRXWX9HtXeo=";
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
