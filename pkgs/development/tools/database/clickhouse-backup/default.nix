{ buildGoModule
, clickhouse-backup
, fetchFromGitHub
, lib
, testers
}:

buildGoModule rec {
  pname = "clickhouse-backup";
  version = "2.5.4";

  src = fetchFromGitHub {
    owner = "AlexAkulov";
    repo = "clickhouse-backup";
    rev = "v${version}";
    hash = "sha256-uFQm7VRxFozV/I1tywey5ljWqzt08aShVjlwUT3oz5w=";
  };

  vendorHash = "sha256-T4afeclCWldFJTzk08Ku8VPnXr/Gz0Fpb7G9YrK/iro=";

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
