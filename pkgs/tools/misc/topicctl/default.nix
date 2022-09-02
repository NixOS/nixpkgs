{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "topicctl";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "segmentio";
    repo = "topicctl";
    rev = "v${version}";
    sha256 = "sha256-7dw1UldffSCoJYhICb7v7XWQdXerSkrKonNNio0PkTQ=";
  };

  vendorSha256 = "sha256-P3o4P6CUDB0jIpmgxgYL7D6TJuaWQBCprsE4NLTLELY=";

  ldflags = [
    "-X main.BuildVersion=${version}"
    "-X main.BuildCommitSha=unknown"
    "-X main.BuildDate=unknown"
  ];

  # needs a kafka server
  doCheck = false;

  meta = with lib; {
    description = "A tool for easy, declarative management of Kafka topics";
    inherit (src.meta) homepage;
    license = licenses.mit;
    maintainers = with maintainers; [ eskytthe srhb ];
  };
}
