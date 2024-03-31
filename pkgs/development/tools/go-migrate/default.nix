{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-migrate";
  version = "4.17.0";

  src = fetchFromGitHub {
    owner = "golang-migrate";
    repo = "migrate";
    rev = "v${version}";
    sha256 = "sha256-lsqSWhozTdLPwqnwYMLxH3kF62MsUCcjzKJ7qTU79qQ=";
  };

  proxyVendor = true; # darwin/linux hash mismatch
  vendorHash = "sha256-3otiRbswhENs/YvKKr+ZeodLWtK7fhCjEtlMDlkLOlY=";

  subPackages = [ "cmd/migrate" ];

  tags = [ "cassandra" "clickhouse" "cockroachdb" "crate" "firebird" "mongodb" "multistmt" "mysql" "neo4j" "pgx" "postgres" "ql" "redshift" "rqlite" "shell" "snowflake" "spanner" "sqlite3" "sqlserver" "stub" "testing" "yugabytedb" ];

  meta = with lib; {
    homepage = "https://github.com/golang-migrate/migrate";
    description = "Database migrations. CLI and Golang library";
    maintainers = with maintainers; [ offline ];
    license = licenses.mit;
    mainProgram = "migrate";
  };
}
