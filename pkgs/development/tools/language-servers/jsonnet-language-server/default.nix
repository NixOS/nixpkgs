{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "jsonnet-language-server";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "jsonnet-language-server";
    rev = "refs/tags/v${version}";
    hash = "sha256-Z7ovjDt7MoV0/YRDOkidTs6O4vwKAVZyioeaNaehZLQ=";
  };

  vendorHash = "sha256-dOs+CasHQt9kcjQENG2rJfTimmkGzayJyGuyE6u8Pz4=";

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
