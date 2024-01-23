{ lib
, buildPythonPackage
, fetchPypi
, setuptools
}:

buildPythonPackage rec {
  pname = "types-psycopg2";
  version = "2.9.21.20240118";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5KBjFufJaQJVF1w+5d/6W0fFBX8XGB9eNMbc2zQGbzU=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  pythonImportsCheck = [
    "psycopg2-stubs"
  ];

  doCheck = false;

  meta = with lib; {
    description = "Typing stubs for psycopg2";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
