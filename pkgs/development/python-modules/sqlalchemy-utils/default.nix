{ lib
, arrow
, babel
, backports-zoneinfo
, buildPythonPackage
, colour
, cryptography
, docutils
, fetchPypi
, flexmock
, furl
, importlib-metadata
#, intervals
, jinja2
, passlib
, pendulum
, pg8000
, phonenumbers
, psycopg2
, psycopg2cffi
, pygments
, pymysql
, pyodbc
, pytestCheckHook
, python-dateutil
, pythonOlder
, pytz
, sqlalchemy
}:

buildPythonPackage rec {
  pname = "sqlalchemy-utils";
  version = "0.41.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit version;
    pname = "SQLAlchemy-Utils";
    hash = "sha256-ohgb/wHuuER544Vx0sBxjrUgQvmv2MGU0NAod+hLfXQ=";
  };

  patches = [
    ./skip-database-tests.patch
  ];

  propagatedBuildInputs = [
    sqlalchemy
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  passthru.optional-dependencies = {
    babel = [
      babel
    ];
    arrow = [
      arrow
    ];
    pendulum = [
      pendulum
    ];
    #intervals = [ intervals ];
    phone = [
      phonenumbers
    ];
    password = [
      passlib
    ];
    color = [
      colour
    ];
    timezone = [
      python-dateutil
    ];
    url = [
      furl
    ];
    encrypted = [
      cryptography
    ];
  };

  nativeCheckInputs = [
    docutils
    flexmock
    jinja2
    pg8000
    psycopg2
    psycopg2cffi
    pygments
    pymysql
    pyodbc
    pytestCheckHook
    pytz
  ]
  ++ lib.flatten (builtins.attrValues passthru.optional-dependencies)
  ++ lib.optionals (pythonOlder "3.9") [
    backports-zoneinfo
  ];

  disabledTests = [
    # Tests are failing
    "test_create_database_twice"
    "test_create_and_drop"
    "test_create_and_drop"
  ];

  pythonImportsCheck = [
    "sqlalchemy_utils"
  ];

  meta = with lib; {
    description = "Various utility functions and datatypes for SQLAlchemy";
    homepage = "https://github.com/kvesteri/sqlalchemy-utils";
    changelog = "https://github.com/kvesteri/sqlalchemy-utils/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ eadwu ];
  };
}
