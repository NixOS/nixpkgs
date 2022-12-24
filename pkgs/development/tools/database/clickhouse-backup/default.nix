{ buildGoModule
, clickhouse-backup
, fetchFromGitHub
, lib
, testers
}:

buildGoModule rec {
  pname = "clickhouse-backup";
  version = "2.1.3";

  src = fetchFromGitHub {
    owner = "AlexAkulov";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-RaThNBTRBECSeSeJOQ2UsrkBHjSjrS91vIRF/4MGek4=";
  };

  vendorSha256 = "sha256-sSN+HAUC9rJc9XMTG8H+Zg7mzZSVxn6Z7dixJ10mOuM=";

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
    maintainers = with maintainers; [ ma27 ];
    platforms = platforms.linux;
  };
}
