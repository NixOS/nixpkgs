{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "sqlboiler";
  version = "4.16.2";

  src = fetchFromGitHub {
    owner = "volatiletech";
    repo = "sqlboiler";
    rev = "refs/tags/v${version}";
    hash = "sha256-akfXYFgBbG/GCatoT820w4adXWqfG9wvHuChaqkewXs=";
  };

  vendorHash = "sha256-BTrQPWThfJ7gWXi/Y1l/s2BmkW5lVYS/PP0WRwntQxA=";

  tags = [
    "mysql"
    "go"
    "golang"
    "postgres"
    "orm"
    "database"
    "postgresql"
    "mssql"
    "sqlite3"
    "sqlboiler"
  ];

  doCheck = false;

  meta = with lib; {
    description = "Generate a Go ORM tailored to your database schema";
    homepage = "https://github.com/volatiletech/sqlboiler";
    changelog = "https://github.com/volatiletech/sqlboiler/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mrityunjaygr8 ];
    mainProgram = "sqlboiler";
  };
}
