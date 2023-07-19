{ lib
, fetchFromGitHub
, python3
, nixosTests
, testers
, sqlite3-to-mysql
, fetchPypi
}:

let
  py = python3.override {
    packageOverrides = self: super: {
      # sqlite3-to-mysql is incompatible with versions > 1.4.44 of sqlalchemy
      sqlalchemy = super.sqlalchemy.overridePythonAttrs rec {
        version = "1.4.44";
        format = "setuptools";
        src = fetchPypi {
          pname = "SQLAlchemy";
          inherit version;
          hash = "sha256-LdpflnGa6Js+wPG3lpjYbrmuyx1U6ZCrs/3ZLAS0apA=";
        };
      };
    };
    self = py;
  };

in
with py.pkgs; buildPythonApplication rec {
  pname = "sqlite3-to-mysql";
  version = "1.4.19";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "techouse";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-gtXwDLHl5f1sXLm+b8l08bY/XJkN+zVtd7m45K0CAYY=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
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
    version = testers.testVersion {
      package = sqlite3-to-mysql;
      command = "sqlite3mysql --version";
    };
  };

  meta = with lib; {
    description = "A simple Python tool to transfer data from SQLite 3 to MySQL";
    homepage = "https://github.com/techouse/sqlite3-to-mysql";
    license = licenses.mit;
    maintainers = with maintainers; [ gador ];
  };
}
