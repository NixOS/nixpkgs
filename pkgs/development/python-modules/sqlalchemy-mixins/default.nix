{ lib
, buildPythonPackage
, fetchFromGitHub
, nose
, pytestCheckHook
, pythonOlder
, six
, sqlalchemy
}:

buildPythonPackage rec {
  pname = "sqlalchemy-mixins";
  version = "1.5.3";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "absent1706";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-GmMxya6aJ7MMqQ3KSqO3f/cbwgWvQYhEVXtGi6fhP1M=";
  };

  propagatedBuildInputs = [
    six
    sqlalchemy
  ];

  checkInputs = [
    nose
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "sqlalchemy_mixins"
  ];

  meta = with lib; {
    description = "Python mixins for SQLAlchemy ORM";
    homepage = "https://github.com/absent1706/sqlalchemy-mixins";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
