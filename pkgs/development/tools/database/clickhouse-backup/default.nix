{ buildGoModule
, clickhouse-backup
, fetchFromGitHub
, lib
, testers
}:

buildGoModule rec {
  pname = "clickhouse-backup";
  version = "2.4.14";

  src = fetchFromGitHub {
    owner = "AlexAkulov";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-M+PwDPisJKcTdcfzZGfN+q+q1hW1beodvDrMV6pjaZU=";
  };

  vendorHash = "sha256-nKlM+xmyp4x0VlNsalLhE8KnFG9rqxTAOFo/jFkUBgE=";

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
