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
  version = "1.5.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "thombashi";
    repo = "SimpleSQLite";
    tag = "v${version}";
    hash = "sha256-PObyZmmECxp6keRymYFGi4Uf07yNHu6rUIqSrRx2bPE=";
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
