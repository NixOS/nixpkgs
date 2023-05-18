{ lib
, buildPythonPackage
, fetchPypi
, paramiko
, python
}:

buildPythonPackage rec {
  pname = "scp";
  version = "0.14.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ZPABWJmz0hLLgIjn1A668Ghoif8OJD1cEkLv6LUPBT4=";
  };

  propagatedBuildInputs = [
    paramiko
  ];

  checkPhase = ''
    SCPPY_PORT=10022 ${python.interpreter} test.py
  '';

  #The Pypi package doesn't include the test
  doCheck = false;

  pythonImportsCheck = [ "scp" ];

  meta = with lib; {
    homepage = "https://github.com/jbardin/scp.py";
    description = "SCP module for paramiko";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ xnaveira ];
  };
}
