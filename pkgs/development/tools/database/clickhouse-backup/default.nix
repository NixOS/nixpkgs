{ buildGoModule
, clickhouse-backup
, fetchFromGitHub
, lib
, testers
}:

buildGoModule rec {
  pname = "clickhouse-backup";
  version = "2.4.33";

  src = fetchFromGitHub {
    owner = "AlexAkulov";
    repo = "clickhouse-backup";
    rev = "v${version}";
    hash = "sha256-IiREE9nzApX+SI5gWOXU8aaQyJrGZcVJarHcKhcHmyo=";
  };

  vendorHash = "sha256-kI2n7vNY7LQC2dLJL7b46X6Sk9ek3E66dSvEdYsxwI8=";

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
