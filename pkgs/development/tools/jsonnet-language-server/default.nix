{ stdenv, lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "jsonnet-language-server";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "jsonnet-language-server";
    rev = "v${version}";
    sha256 = "sha256-RpjLIz5lfdWULTDTMDVYvTTSaQWvYbvpxvs4L5UldjM=";
  };

  vendorSha256 = "sha256-imFr4N/YmpwjVZSCBHG7cyJt4RKTn+T7VPdL8R/ba5o=";

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
