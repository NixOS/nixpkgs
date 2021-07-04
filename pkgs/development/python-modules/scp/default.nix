{ lib
, buildPythonPackage
, fetchPypi
, paramiko
, python
}:

buildPythonPackage rec {
  pname = "scp";
  version = "0.13.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-CrLukXi4vlPcXJ/i8zdh4BokNQh/XJ+1tUUZhzxlDWA=";
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
