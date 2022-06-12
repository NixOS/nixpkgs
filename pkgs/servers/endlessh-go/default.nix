{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "endlessh-go";
  version = "20220308.1";

  src = fetchFromGitHub {
    owner = "shizunge";
    repo = "endlessh-go";
    rev = version;
    hash = "sha256-U+h/WmTVwwUIBEOiNa/EKS6HvkeoGNmP3NpeP1fcqYw=";
  };

  vendorSha256 = "sha256-h/DpbXO+LUsB9NOAXUfNx3VOfEsiolfBEMBrAqVlU3A=";

  proxyVendor = true;

  meta = with lib; {
    description = "An implementation of endlessh exporting Prometheus metrics";
    homepage = "https://github.com/shizunge/endlessh-go";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ azahi ];
  };
}
