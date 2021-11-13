{ lib
, buildPythonPackage
, fetchPypi
, paramiko
, python
}:

buildPythonPackage rec {
  pname = "scp";
  version = "0.14.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b776bd6ce8c8385aa9a025b64a9815b5d798f12d4ef0d712d569503f62aece8b";
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
