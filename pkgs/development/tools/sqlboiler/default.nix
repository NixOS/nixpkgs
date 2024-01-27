{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "sqlboiler";
  version = "4.15.0";

  src = fetchFromGitHub {
    owner = "volatiletech";
    repo = "sqlboiler";
    rev = "refs/tags/v${version}";
    hash = "sha256-MT1tjVCDaFB9HfjlGGnf6jTiPdKcrDamgp2nTpIarqY=";
  };

  vendorHash = "sha256-tZ1RQGmeDv4rtdF1WTRQV1K4Xy1AgIatLPPexnHJnkA=";

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
