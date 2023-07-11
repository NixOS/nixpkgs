{ buildGoModule
, clickhouse-backup
, fetchFromGitHub
, lib
, testers
}:

buildGoModule rec {
  pname = "clickhouse-backup";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "AlexAkulov";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-yhRBaxt+hMNgnZK3qHgBnkRK/bWXeDfWHkiWzMLJn/g=";
  };

  vendorHash = "sha256-YSr3fKqJJtNRbUW1TjwDM96cA6CoYz1LUit/pC8V3Fs=";

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
    homepage = "https://github.com/AlexAkulov/clickhouse-backup";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
