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
  version = "1.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "penguinolog";
    repo = "sqlalchemy_jsonfield";
    rev = version;
    sha256 = "015pl4z84spfw8389hk1szlm37jgw2basvbmzmkacdqi0685zx24";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = "v${version}";

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    sqlalchemy
    setuptools
  ];

  checkInputs = [
    pytestCheckHook
    pytest-sugar
    pymysql
    psycopg2
  ];

  pythonImportsCheck = [
    "sqlalchemy_jsonfield"
  ];

  meta = with lib; {
    homepage = "https://github.com/penguinolog/sqlalchemy_jsonfield";
    description = "SQLALchemy JSONField implementation for storing dicts at SQL independently from JSON type support";
    license = licenses.asl20;
    maintainers = with maintainers; [ ivan-tkatchev ];
  };
}
