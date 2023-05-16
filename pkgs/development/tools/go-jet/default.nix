{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "go-jet";
<<<<<<< HEAD
  version = "2.10.1";
=======
  version = "2.10.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = pname;
    repo = "jet";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-G/yKS4YFKOVkuoqT/Qh12ul43dKo4W23EIyCgmeaUoo=";
=======
    sha256 = "sha256-Dj/Bq7MEM2sIhz1ThvRpO9wYCasISvd8icP68LVXEx0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
