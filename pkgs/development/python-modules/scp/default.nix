{ stdenv
, buildPythonPackage
, fetchPypi
, paramiko
, python
}:

buildPythonPackage rec {
  pname = "scp";
  version = "0.12.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0cjyc19v46lwrhdyc18f87z589rhqg7zjg0s8a05w6mv3262b6ai";
  };

  propagatedBuildInputs = [
    paramiko
  ];

  checkPhase = ''
    SCPPY_PORT=10022 ${python.interpreter} test.py
  '';

  #The Pypi package doesn't include the test
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://github.com/jbardin/scp.py;
    description = "SCP module for paramiko";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ xnaveira ];
  };
}
