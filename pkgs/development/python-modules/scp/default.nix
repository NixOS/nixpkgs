{ lib
, buildPythonPackage
, fetchPypi
, paramiko
, python
}:

buildPythonPackage rec {
  pname = "scp";
  version = "0.14.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ddbdb3ef8c068aa1fd37a5fa65a122a80673c9fd73fdc5668a4604f99ccf5943";
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
