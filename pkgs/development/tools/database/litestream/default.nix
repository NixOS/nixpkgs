{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:
buildGoModule rec {
  pname = "litestream";
  version = "0.3.13";

  src = fetchFromGitHub {
    owner = "benbjohnson";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-p858gK+ICKDQ+/LUiBaxF/kfrZzQAXnYMZDFU8kNCJ4=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];

  vendorHash = "sha256-sYIY3Z3VrCqbjEbQtEY7q6Jljg8jMoa2qWEB/IkDjzM=";

  meta = with lib; {
    description = "Streaming replication for SQLite";
    mainProgram = "litestream";
    license = licenses.asl20;
    homepage = "https://litestream.io/";
    maintainers = with maintainers; [ fbrs ];
    knownVulnerabilities = [ "CVE-2024-41254" ];
  };
}
