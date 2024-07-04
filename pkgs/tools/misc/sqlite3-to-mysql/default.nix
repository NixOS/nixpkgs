{ lib
, fetchFromGitHub
, python3Packages
, nixosTests
, testers
, sqlite3-to-mysql
, mysql80
}:

python3Packages.buildPythonApplication rec {
  pname = "sqlite3-to-mysql";
  version = "2.2.0";
  format = "pyproject";

  disabled = python3Packages.pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "techouse";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-oav5HJdTmSAKk1b0wpzU2UOoY53zh5BrQ3Q0N360NeQ=";
  };

  nativeBuildInputs = with python3Packages; [
    hatchling
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = with python3Packages; [
    click
    mysql-connector
    pytimeparse2
    pymysql
    pymysqlsa
    simplejson
    sqlalchemy
    sqlalchemy-utils
    tqdm
    tabulate
    unidecode
    packaging
    mysql80
  ];

  pythonRelaxDeps = [
    "mysql-connector-python"
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
    description = "Simple Python tool to transfer data from SQLite 3 to MySQL";
    homepage = "https://github.com/techouse/sqlite3-to-mysql";
    license = licenses.mit;
    maintainers = with maintainers; [ gador ];
    mainProgram = "sqlite3mysql";
  };
}
