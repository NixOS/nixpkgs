{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "endlessh-go";
  version = "20220213";

  src = fetchFromGitHub {
    owner = "shizunge";
    repo = "endlessh-go";
    rev = version;
    sha256 = "sha256-x/38w0GtzYBGWr0ZkfY2HmDEAUI54R833aH0RZSCTC0=";
  };
  vendorSha256 = "sha256-h/DpbXO+LUsB9NOAXUfNx3VOfEsiolfBEMBrAqVlU3A=";
  proxyVendor = true;

  meta = with lib; {
    homepage = "https://github.com/shizunge/endlessh-go";
    description = "An implementation of endlessh exporting Prometheus metrics";
    license = licenses.gpl3;
    maintainers = with maintainers; [ azahi ];
  };
}
