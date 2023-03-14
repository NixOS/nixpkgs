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
    sha256 = "sha256-bMu806T4olpewEmR85oLjbUt/NSH6g5XjZd+Z1I4AzM=";
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
