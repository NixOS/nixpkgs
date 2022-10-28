{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "sqlboiler";
  version = "4.13.0";

  src = fetchFromGitHub {
    owner = "volatiletech";
    repo = "sqlboiler";
    rev = "v${version}";
    sha256 = "sha256-vSHr6c06d0b6ZF0YlBAIE7NvBqvcn+phoRlFvP5nlUM=";
  };

  vendorSha256 = "sha256-r8lvsmzo0uiPqSPq2WX7ZMMrl+zYj+c6bta4CGgnUG8";

  preCheck = ''
     # attempts to run go mod tidy
    rm -v boilingcore/boilingcore_test.go || true

    # attempts to access a running testdb which does not exist
    rm -v drivers/sqlboiler-mssql/driver/mssql_test.go \
    drivers/sqlboiler-mysql/driver/mysql_test.go \
    drivers/sqlboiler-sqlite3/driver/sqlite3_test.go \
    drivers/sqlboiler-psql/driver/psql_test.go || true
  '';

  meta = with lib; {
    description = "SQLBoiler is a tool to generate a Go ORM tailored to your database schema.";
    homepage = https://github.com/volatiletech/sqlboiler;
    changelog = "https://github.com/volatiletech/sqlboiler/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dgollings ];
    platforms = platforms.linux ++ platforms.darwin;
    mainProgram = "sqlboiler";
  };
}
