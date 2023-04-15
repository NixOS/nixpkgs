{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "sqlboiler";
  version = "4.14.2";

  src = fetchFromGitHub {
    owner = "volatiletech";
    repo = "sqlboiler";
    rev = "v${version}";
    sha256 = "sha256-d3SML1cm+daYU5dEuwSXSsKwsJHxGuOEbwCvYfsMcFI=";
  };

  vendorSha256 = "sha256-/z5l+tgQuYBZ0A99A8CoTuqTSfnM52R43ppFrooRgOM=";

  tags = [ "mysql" "go" "golang" "postgres" "orm" "database" "postgresql" "mssql" "sqlite3" "sqlboiler" ];

  doCheck = false;


  meta = with lib; {
    homepage = "https://github.com/volatiletech/sqlboiler";
    description = "Generate a Go ORM tailored to your database schema.";
    maintainers = with maintainers; [ mrityunjaygr8 ];
    license = licenses.bsd3;
    mainProgram = "sqlboiler";
  };
}
