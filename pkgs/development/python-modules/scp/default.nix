{ stdenv
, buildPythonPackage
, fetchPypi
, paramiko
, python
}:

buildPythonPackage rec {
  pname = "scp";
  version = "0.13.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "09219c45hafq6pb8z6rsinsfhp3rsx5mr9cgz2099rcs4if2gk6g";
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
