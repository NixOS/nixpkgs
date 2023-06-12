{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-migrate";
  version = "4.16.1";

  src = fetchFromGitHub {
    owner = "golang-migrate";
    repo = "migrate";
    rev = "v${version}";
    sha256 = "sha256-XpZX8a/ITFyqz5TabzjHgz4iWjP09Q7Fuy5EpYp4sKs=";
  };

  vendorHash = "sha256-dOd5aYV7h5Bma32btEa0UpA3dnIIhwM/rl7hWrPvgMM=";

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
