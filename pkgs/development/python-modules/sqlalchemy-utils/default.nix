{
  lib,
  buildPythonPackage,
  arrow,
  babel,
  colour,
  cryptography,
  docutils,
  fetchFromGitHub,
  flexmock,
  furl,
  # intervals,
  jinja2,
  passlib,
  pendulum,
  pg8000,
  phonenumbers,
  psycopg2,
  psycopg2cffi,
  pygments,
  pymysql,
  pyodbc,
  pytestCheckHook,
  python-dateutil,
  pythonAtLeast,
  pythonOlder,
  pytz,
  setuptools,
  sqlalchemy,
}:

buildPythonPackage rec {
  pname = "sqlalchemy-utils";
  version = "0.42.2";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "kvesteri";
    repo = "sqlalchemy-utils";
    tag = version;
    hash = "sha256-jC8onlCiuzpMlJ3EzpzCnQ128xpkLzrZEuGWQv7pvVE=";
  };

  patches = [ ./skip-database-tests.patch ];

  build-system = [ setuptools ];

  propagatedBuildInputs = [ sqlalchemy ];

  optional-dependencies = {
    babel = [ babel ];
    arrow = [ arrow ];
    pendulum = [ pendulum ];
    #intervals = [ intervals ];
    phone = [ phonenumbers ];
    password = [ passlib ];
    color = [ colour ];
    timezone = [ python-dateutil ];
    url = [ furl ];
    encrypted = [ cryptography ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pygments
    jinja2
    docutils
    flexmock
    psycopg2
    pg8000
    pytz
    python-dateutil
    pymysql
    pyodbc
  ]
  ++ lib.concatAttrValues optional-dependencies
  ++ lib.optionals (pythonOlder "3.12") [
    # requires distutils, which were removed in 3.12
    psycopg2cffi
  ];

  disabledTests = [
    "test_create_database_twice"
    "test_create_and_drop"
  ]
  ++ lib.optionals (pythonAtLeast "3.13") [
    # https://github.com/kvesteri/sqlalchemy-utils/issues/764
    "test_render_mock_ddl"
  ];

  pytestFlags = [
    "-Wignore::DeprecationWarning"
  ];

  pythonImportsCheck = [ "sqlalchemy_utils" ];

  meta = with lib; {
    description = "Various utility functions and datatypes for SQLAlchemy";
    homepage = "https://github.com/kvesteri/sqlalchemy-utils";
    changelog = "https://github.com/kvesteri/sqlalchemy-utils/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ eadwu ];
  };
}
