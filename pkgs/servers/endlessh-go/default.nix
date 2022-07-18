{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "endlessh-go";
  version = "20220710";

  src = fetchFromGitHub {
    owner = "shizunge";
    repo = "endlessh-go";
    rev = version;
    sha256 = "sha256-T8DLzHfITMLeHJtKuK4AjEzGGCIDJUPlqF2Lj56xPxY=";
  };

  vendorSha256 = "sha256-hMCjYAqsI6h9B8iGVYQcNbKU5icalOHavvPKwOmvf/w=";

  proxyVendor = true;

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "An implementation of endlessh exporting Prometheus metrics";
    homepage = "https://github.com/shizunge/endlessh-go";
    changelog = "https://github.com/shizunge/endlessh-go/releases/tag/${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ azahi ];
  };
}
