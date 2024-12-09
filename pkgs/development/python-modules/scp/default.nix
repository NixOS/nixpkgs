{
  lib,
  buildPythonPackage,
  fetchPypi,
  paramiko,
  python,
}:

buildPythonPackage rec {
  pname = "scp";
  version = "0.15.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8bIumTISPM8X7r8Z4JU8bpFI9Yn5PZG4cpQaaWMFyD8=";
  };

  propagatedBuildInputs = [ paramiko ];

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
