{ lib
, buildPythonPackage
, fetchPypi
, paramiko
, pytestCheckHook
, tornado
}:

buildPythonPackage rec {
  pname = "webssh";
  version = "1.5.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Au6PE8jYm8LkEp0B1ymW//ZkrkcV0BauwufQmrHLEU4=";
  };

  propagatedBuildInputs = [
    paramiko
    tornado
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "webssh"
  ];

  meta = with lib; {
    description = "Web based SSH client";
    homepage = "https://github.com/huashengdun/webssh/";
    license = licenses.mit;
    maintainers = with maintainers; [ davidtwco ];
  };
}
