{ buildGoModule
, clickhouse-backup
, fetchFromGitHub
, lib
, testers
}:

buildGoModule rec {
  pname = "clickhouse-backup";
  version = "2.4.35";

  src = fetchFromGitHub {
    owner = "AlexAkulov";
    repo = "clickhouse-backup";
    rev = "v${version}";
    hash = "sha256-SE4+NUH1W0YPjx59yjOun1tLbn6Je2nG2wcfb8+YSfw=";
  };

  vendorHash = "sha256-5da3Tt4rKbzFPwYVhkkxCY/YpJePdE7WLDlTtPI8w1Q=";

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
