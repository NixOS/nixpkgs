{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tempo";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "tempo";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-m7tfDd0Yjg4+VHZPxYJXEx2XNNodepMcPLucBjvd88s=";
  };

  vendorSha256 = null;

  subPackages = [
    "cmd/tempo-cli"
    "cmd/tempo-query"
    "cmd/tempo-serverless"
    "cmd/tempo-vulture"
    "cmd/tempo"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${version}"
    "-X=main.Branch=<release>"
    "-X=main.Revision=${version}"
  ];

  # tests use docker
  doCheck = false;

  meta = with lib; {
    description = "A high volume, minimal dependency trace storage";
    license = licenses.asl20;
    homepage = "https://grafana.com/oss/tempo/";
    maintainers = with maintainers; [ willibutz ];
    platforms = platforms.linux;
  };
}
