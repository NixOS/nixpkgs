{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "jsonnet-language-server";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "jsonnet-language-server";
    rev = "refs/tags/v${version}";
    hash = "sha256-8hy+lRh6WqyjInqGD21GHdS0QWz8g0e8MdZbQblv8II=";
  };

  vendorHash = "sha256-/mfwBHaouYN8JIxPz720/7MlMVh+5EEB+ocnYe4B020=";

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
