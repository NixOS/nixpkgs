{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-jet";
  version = "2.10.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = "jet";
    rev = "v${version}";
    sha256 = "sha256-G/yKS4YFKOVkuoqT/Qh12ul43dKo4W23EIyCgmeaUoo=";
  };

  vendorHash = "sha256-AwrtLTzKqKjFf5fV3JWYWyaqzHJjMNrYuSXhHXyV5HE=";

  subPackages = [ "cmd/jet" ];

  tags = [
    "mysql"
    "golang"
    "postgres"
    "sql"
    "database"
    "code-generator"
    "sqlite"
    "postgresql"
    "mariadb"
    "sql-query"
    "codegenerator"
    "typesafe"
    "sql-builder"
    "datamapper"
    "code-completion"
    "sql-queries"
    "cockroachdb"
    "sql-query-builder"
    "sqlbuilder"
    "typesafety"
  ];

  postPatch = ''
    # removing the tests which depend on external data
    rm -rf tests/{sqlite,postgres,mysql}
  '';

  meta = with lib; {
    homepage = "https://github.com/go-jet/jet";
    description = "Type safe SQL builder with code generation and automatic query result data mapping";
    maintainers = with maintainers; [ mrityunjaygr8 ];
    license = licenses.asl20;
    mainProgram = "jet";
  };
}
