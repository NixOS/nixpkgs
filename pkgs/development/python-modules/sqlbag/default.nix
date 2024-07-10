{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  psycopg2,
  pymysql,
  sqlalchemy,
  six,
  flask,
  pendulum,
  packaging,
  setuptools,
  poetry-core,
  pytestCheckHook,
  pytest-xdist,
  pytest-sugar,
  postgresql,
  postgresqlTestHook,
}:
buildPythonPackage rec {
  pname = "sqlbag";
  version = "0.1.1617247075";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "djrobstep";
    repo = pname;
    # no tags on github, version patch number is unix time.
    rev = "eaaeec4158ffa139fba1ec30d7887f4d836f4120";
    hash = "sha256-lipgnkqrzjzqwbhtVcWDQypBNzq6Dct/qoM8y/FNiNs=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    sqlalchemy
    six
    packaging

    psycopg2
    pymysql

    setuptools # needed for 'pkg_resources'
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
    pytest-sugar

    postgresql
    postgresqlTestHook

    flask
    pendulum
  ];

  preCheck = ''
    export PGUSER="nixbld";
  '';
  disabledTests = [
    # These all fail with "List argument must consist only of tuples or dictionaries":
    # Related issue: https://github.com/djrobstep/sqlbag/issues/14
    "test_basic"
    "test_createdrop"
    "test_errors_and_messages"
    "test_flask_integration"
    "test_orm_stuff"
    "test_pendulum_for_time_types"
    "test_transaction_separation"
  ];

  pytestFlagsArray = [
    "-x"
    "-svv"
    "tests"
  ];

  pythonImportsCheck = [ "sqlbag" ];

  meta = with lib; {
    description = "Handy python code for doing database things";
    homepage = "https://github.com/djrobstep/sqlbag";
    license = with licenses; [ unlicense ];
    maintainers = with maintainers; [ soispha ];
    broken = true; # Fails to build against the current flask version
  };
}
