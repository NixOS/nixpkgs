{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "jsonnet-language-server";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "jsonnet-language-server";
    rev = "refs/tags/v${version}";
    hash = "sha256-oPItt1v4wK0W0lSots3hoq5A1ooCRwzJV8cNYV+SBb4=";
  };

  vendorHash = "sha256-ZyTo79M5nqtqrtTOGanzgHcnSvqCKACacNBWzhYG5nY=";

  ldflags = [
    "-s"
    "-w"
    "-X 'main.version=${version}'"
  ];

  meta = with lib; {
    description = "Language Server Protocol server for Jsonnet";
    homepage = "https://github.com/grafana/jsonnet-language-server";
    changelog = "https://github.com/grafana/jsonnet-language-server/releases/tag/v${version}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ hardselius ];
  };
}
