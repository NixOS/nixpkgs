{ stdenv
, buildPythonPackage
, fetchPypi
, paramiko
, python
}:

buildPythonPackage rec {
  pname = "scp";
  version = "0.10.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "18f59e48df67fac0b069591609a0f4d50d781a101ddb8ec705f0c2e3501a8386";
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
