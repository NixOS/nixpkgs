{ lib
, buildPythonPackage
, fetchPypi
, flask
, flask-login
, flask-sqlalchemy
<<<<<<< HEAD
=======
, flexmock
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, psycopg2
, pymysql
, pytestCheckHook
, pythonOlder
, sqlalchemy
, sqlalchemy-i18n
, sqlalchemy-utils
}:

buildPythonPackage rec {
  pname = "sqlalchemy-continuum";
<<<<<<< HEAD
  version = "1.4.0";
=======
  version = "1.3.14";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "SQLAlchemy-Continuum";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-Rk+aWxBjUrXuRPE5MSyzWMWS0l7qrjU3wOrHLC+vteU=";
=======
    hash = "sha256-1+k/lx6R8tW9gM3M2kqaVEwpmx8cMhDXeqCjyd8O2hM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    sqlalchemy
    sqlalchemy-utils
  ];

  passthru.optional-dependencies = {
    flask = [
      flask
    ];
    flask-login = [
      flask-login
    ];
    flask-sqlalchemy = [
      flask-sqlalchemy
    ];
<<<<<<< HEAD
=======
    flexmock = [
      flexmock
    ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    i18n = [
      sqlalchemy-i18n
    ];
  };

  nativeCheckInputs = [
    psycopg2
    pymysql
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  # Indicate tests that we don't have a database server at hand
<<<<<<< HEAD
  env.DB = "sqlite";
=======
  DB = "sqlite";

  disabledTestPaths = [
    # Test doesn't support latest SQLAlchemy
    "tests/plugins/test_flask.py"
  ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  pythonImportsCheck = [
    "sqlalchemy_continuum"
  ];

  meta = with lib; {
    description = "Versioning and auditing extension for SQLAlchemy";
    homepage = "https://github.com/kvesteri/sqlalchemy-continuum/";
    changelog = "https://github.com/kvesteri/sqlalchemy-continuum/blob/${version}/CHANGES.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
<<<<<<< HEAD
=======

    # https://github.com/kvesteri/sqlalchemy-continuum/issues/326
    broken = versionAtLeast sqlalchemy.version "2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
