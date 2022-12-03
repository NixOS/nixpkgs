{ stdenv, lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "jsonnet-language-server";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "jsonnet-language-server";
    rev = "v${version}";
    sha256 = "sha256-oPItt1v4wK0W0lSots3hoq5A1ooCRwzJV8cNYV+SBb4=";
  };

  vendorSha256 = "sha256-ZyTo79M5nqtqrtTOGanzgHcnSvqCKACacNBWzhYG5nY=";

  ldflags = [
    "-s -w -X 'main.version=${version}'"
  ];

  meta = with lib; {
    homepage = "https://github.com/grafana/jsonnet-language-server";
    description = "Language Server Protocol server for Jsonnet";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ hardselius ];
  };
}
