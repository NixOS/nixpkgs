{ stdenv
, buildPythonPackage
, fetchPypi
, paramiko
, python
}:

buildPythonPackage rec {
  pname = "scp";
  version = "0.13.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1crlpw9lnn58fs1c1rmh7s7s9y5gkgpgjsqlvg9qa51kq1knx7gg";
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
