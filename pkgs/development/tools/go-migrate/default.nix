{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-migrate";
  version = "4.17.1";

  src = fetchFromGitHub {
    owner = "golang-migrate";
    repo = "migrate";
    rev = "v${version}";
    sha256 = "sha256-9PJ3XxEA2PEaPFE3BbZkJB8XdJmm0gZf2Ko5T9DAZBw=";
  };

  proxyVendor = true; # darwin/linux hash mismatch
  vendorHash = "sha256-03nNN1FkGee01gNOmIASc2B7mMTes1pEDc6Lo08dhcw=";

  subPackages = [ "cmd/migrate" ];

  tags = [ "cassandra" "clickhouse" "cockroachdb" "crate" "firebird" "mongodb" "multistmt" "mysql" "neo4j" "pgx" "pgx5" "postgres" "ql" "redshift" "rqlite" "shell" "snowflake" "spanner" "sqlite3" "sqlserver" "stub" "testing" "yugabytedb" ];

  meta = with lib; {
    homepage = "https://github.com/golang-migrate/migrate";
    description = "Database migrations. CLI and Golang library";
    maintainers = with maintainers; [ offline ];
    license = licenses.mit;
    mainProgram = "migrate";
  };
}
