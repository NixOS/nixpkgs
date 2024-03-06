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

  tags = [ "postgres" "mysql" "redshift" "cassandra" "spanner" "cockroachdb" "clickhouse" "mongodb" "sqlserver" "firebird" "neo4j" "pgx" ];

  meta = with lib; {
    homepage = "https://github.com/golang-migrate/migrate";
    description = "Database migrations. CLI and Golang library";
    maintainers = with maintainers; [ offline ];
    license = licenses.mit;
    mainProgram = "migrate";
  };
}
