{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, setuptools_scm
, sqlalchemy
, typing
  # Check Inputs
, pytestCheckHook
, psycopg2
, pymysql
}:

buildPythonPackage rec {
  pname = "sqlalchemy-jsonfield";
  version = "1.0.0";

  src = fetchPypi {
    pname = "SQLAlchemy-JSONField";
    inherit version;
    sha256 = "766d0b25bdebf53f67ccfaf9975987f921965987b37bae3a95ba6e7855afe98b";
  };

  nativeBuildInputs = [
    setuptools_scm
  ];

  propagatedBuildInputs = [ sqlalchemy ] ++ lib.optional (pythonOlder "3.7") typing;

  checkInputs = [ pytestCheckHook psycopg2 pymysql ];

  meta = with lib; {
    description = "SQLALchemy JSONField implementation for storing dicts as SQL";
    homepage = "https://github.com/penguinolog/sqlalchemy_jsonfield";
    changelog = "https://github.com/penguinolog/sqlalchemy_jsonfield/blob/master/CHANGELOG.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
