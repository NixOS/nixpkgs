{ lib
, buildPythonPackage
, fetchFromGitHub
, sqlalchemy
, setuptools-scm
, setuptools
, tox
, sphinx
, pytest
, pytest-cov
, pytest-html
, pytest-sugar
, coverage
, pymysql
, psycopg2 }:

buildPythonPackage rec {
  pname = "sqlalchemy-jsonfield";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "penguinolog";
    repo = "sqlalchemy_jsonfield";
    rev = version;
    sha256 = "015pl4z84spfw8389hk1szlm37jgw2basvbmzmkacdqi0685zx24";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = "v${version}";

  nativeBuildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [ sqlalchemy setuptools ];
  checkInputs = [ tox sphinx pytest pytest-cov pytest-html pytest-sugar coverage pymysql psycopg2 ];

  checkPhase = ''
    TOX_TESTENV_PASSENV="PYTHONPATH SETUPTOOLS_SCM_PRETEND_VERSION" tox -e functional
  '';

  meta = with lib; {
    homepage = "https://github.com/penguinolog/sqlalchemy_jsonfield";
    description = "SQLALchemy JSONField implementation for storing dicts at SQL independently from JSON type support";
    license = licenses.asl20;
    maintainers = [ maintainers.ivan-tkatchev ];
  };
}
