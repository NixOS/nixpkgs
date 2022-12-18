{ lib
, fetchFromGitHub
, python3Packages
, nixosTests
}:

python3Packages.buildPythonApplication rec {
  pname = "sqlite3-to-mysql";
  version = "1.4.16";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "techouse";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-Fxt1zOyEnBuMkCLCABfijo0514NbFocdsjrQU43qVhY=";
  };

  propagatedBuildInputs = with python3Packages; [
    click
    mysql-connector
    pytimeparse
    pymysql
    pymysqlsa
    six
    simplejson
    sqlalchemy
    sqlalchemy-utils
    tqdm
    tabulate
    unidecode
    packaging
  ];

  # tests require a mysql server instance
  doCheck = false;

  # run package tests as a separate nixos test
  passthru.tests = {
    nixosTest = nixosTests.sqlite3-to-mysql;
  };


  meta = with lib; {
    description = "A simple Python tool to transfer data from SQLite 3 to MySQL";
    homepage = "https://github.com/techouse/sqlite3-to-mysql";
    license = licenses.mit;
    maintainers = with maintainers; [ gador ];
  };
}
