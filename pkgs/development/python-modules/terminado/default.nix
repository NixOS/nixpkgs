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
  version = "0.15.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-q07u3M/MHmE0v+6GEGr5CFLGnWAohOo6Hoym1Ehum/4=";
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

  checkInputs = [
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
