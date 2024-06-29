{ buildGoModule
, clickhouse-backup
, fetchFromGitHub
, lib
, testers
}:

buildGoModule rec {
  pname = "clickhouse-backup";
  version = "2.5.15";

  src = fetchFromGitHub {
    owner = "Altinity";
    repo = "clickhouse-backup";
    rev = "v${version}";
    hash = "sha256-FKOpHvturPJQOhWJh5I7JwDhp0X0Y0ppFejTW1hG6Fk=";
  };

  vendorHash = "sha256-vwcItklYe6ljFdGTxef19plaI5OMoOtQohY0xZLBUos=";

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
    description = "Tool for easy ClickHouse backup and restore using object storage for backup files";
    mainProgram = "clickhouse-backup";
    homepage = "https://github.com/Altinity/clickhouse-backup";
    license = licenses.mit;
    maintainers = with maintainers; [ devusb ];
  };
}
