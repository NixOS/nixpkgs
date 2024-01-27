{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, sqlalchemy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "sqlalchemy-views";
  version = "0.3.2";
  format = "setuptools";

  src = fetchFromGitHub {
    repo = pname;
    owner = "jklukas";
    rev = "refs/tags/v${version}";
    hash = "sha256-MJgikWXo3lpMsSYbb5sOSOTbJPOx5gEghW1V9jKvHKU=";
  };

  postPatch = ''
    substituteInPlace tox.ini --replace '--cov=sqlalchemy_views --cov-report=term' ""
  '';

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    sqlalchemy
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "sqlalchemy_views"
  ];

  meta = with lib; {
    description = "Adds CreateView and DropView constructs to SQLAlchemy";
    homepage = "https://github.com/jklukas/sqlalchemy-views";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
  };
}
