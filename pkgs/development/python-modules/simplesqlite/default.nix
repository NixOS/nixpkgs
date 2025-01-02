{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  dataproperty,
  mbstrdecoder,
  pathvalidate,
  sqliteschema,
  setuptools,
  tabledata,
  typepy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "SimpleSQLite";
  version = "1.5.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "thombashi";
    repo = "SimpleSQLite";
    rev = "v${version}";
    hash = "sha256-Yr17T0/EwVaOjG+mzdxopivj0fuvQdZdX1bFj8vq0MM=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    dataproperty
    mbstrdecoder
    pathvalidate
    sqliteschema
    tabledata
    typepy
  ];

  nativeCheckInputs = [ pytestCheckHook ];
  pythonImportsCheck = [ "simplesqlite" ];

  meta = with lib; {
    description = "Python library to simplify SQLite database operations";
    homepage = "https://github.com/thombashi/simplesqlite";
    license = licenses.mit;
    maintainers = with maintainers; [ henrirosten ];
  };
}
