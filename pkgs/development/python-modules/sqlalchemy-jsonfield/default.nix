{ lib
, buildPythonPackage
, fetchFromGitHub
, sqlalchemy
, setuptools-scm
, setuptools
, sphinx
, pytestCheckHook
, pytest-sugar
, pymysql
, psycopg2
, pythonOlder
}:

buildPythonPackage rec {
  pname = "sqlalchemy-jsonfield";
  version = "1.0.1.post0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "penguinolog";
    repo = "sqlalchemy_jsonfield";
    rev = "refs/tags/${version}";
    sha256 = "sha256-dSvqUXZzr+s/v8QEtqrv6slI7p1akXwAxi68D9ctyuU=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = "v${version}";

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    sqlalchemy
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-sugar
    pymysql
    psycopg2
  ];

  pythonImportsCheck = [
    "sqlalchemy_jsonfield"
  ];

  meta = with lib; {
    description = "SQLALchemy JSONField implementation for storing dicts at SQL independently from JSON type support";
    homepage = "https://github.com/penguinolog/sqlalchemy_jsonfield";
    changelog = "https://github.com/penguinolog/sqlalchemy_jsonfield/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ ivan-tkatchev ];
  };
}
