{ buildGoModule
, clickhouse-backup
, fetchFromGitHub
, lib
, testers
}:

buildGoModule rec {
  pname = "clickhouse-backup";
  version = "2.5.8";

  src = fetchFromGitHub {
    owner = "AlexAkulov";
    repo = "clickhouse-backup";
    rev = "v${version}";
    hash = "sha256-ZXL7o3rXzX+Ziun00YM7+LD4/IbMyAVYg2N8FXzVUy4=";
  };

  vendorHash = "sha256-ybKCD8mZ8MumKsWicS09E/BW0laAPy1iqA6q8lfczHA=";

  ldflags = [
    "-X main.version=${version}"
  ];

  postConfigure = ''
    export CGO_ENABLED=0
  '';

  passthru.tests.version = testers.testVersion {
    package = clickhouse-backup;
  };

  meta = with lib; {
    description = "Tool for easy ClickHouse backup and restore with cloud storages support";
    mainProgram = "clickhouse-backup";
    homepage = "https://github.com/AlexAkulov/clickhouse-backup";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
