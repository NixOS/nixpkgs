{ lib
, buildPythonPackage
, fetchPypi
, hatchling
, ptyprocess
, tornado
, pytest-timeout
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "terminado";
  version = "0.17.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bMu806T4olpewEmR85oLjbUt/NSH6g5XjZd+Z1I4AzM=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    ptyprocess
    tornado
  ];

  pythonImportsCheck = [
    "terminado"
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    pytest-timeout
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Terminals served by Tornado websockets";
    homepage = "https://github.com/jupyter/terminado";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
  };
}
