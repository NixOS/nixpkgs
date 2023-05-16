{ lib
, fetchFromGitHub
, python3Packages
, nixosTests
<<<<<<< HEAD
, testers
, sqlite3-to-mysql
, fetchPypi
, mysql80
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

python3Packages.buildPythonApplication rec {
  pname = "sqlite3-to-mysql";
<<<<<<< HEAD
  version = "2.0.3";
  format = "pyproject";

  disabled = python3Packages.pythonOlder "3.7";
=======
  version = "1.4.16";
  format = "setuptools";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "techouse";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-rlKJKthop9BQnqjTUq1hZM/NP69gPdEFTq1rU+CbpWA=";
  };

  nativeBuildInputs = with python3Packages; [
    hatchling
  ];

  propagatedBuildInputs = with python3Packages; [
    click
    mysql-connector
    pytimeparse2
    pymysql
    pymysqlsa
=======
    hash = "sha256-Fxt1zOyEnBuMkCLCABfijo0514NbFocdsjrQU43qVhY=";
  };

  propagatedBuildInputs = with python3Packages; [
    click
    mysql-connector
    pytimeparse
    pymysql
    pymysqlsa
    six
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    simplejson
    sqlalchemy
    sqlalchemy-utils
    tqdm
    tabulate
    unidecode
    packaging
<<<<<<< HEAD
    mysql80
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  # tests require a mysql server instance
  doCheck = false;

  # run package tests as a separate nixos test
  passthru.tests = {
    nixosTest = nixosTests.sqlite3-to-mysql;
<<<<<<< HEAD
    version = testers.testVersion {
      package = sqlite3-to-mysql;
      command = "sqlite3mysql --version";
    };
  };

=======
  };


>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "A simple Python tool to transfer data from SQLite 3 to MySQL";
    homepage = "https://github.com/techouse/sqlite3-to-mysql";
    license = licenses.mit;
    maintainers = with maintainers; [ gador ];
  };
}
