{ stdenv, lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "jsonnet-language-server";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "jsonnet-language-server";
    rev = "v${version}";
    sha256 = "sha256-lcaC6sOZyfQFKopCKOt855nib1BzK8eitY8pvmX3PQ4=";
  };

  vendorSha256 = "sha256-tsVevkMHuCv70A9Ohg9L+ghH5+v52X4sToI4bMlDzzo=";

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
