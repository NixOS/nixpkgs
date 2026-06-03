{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  paramiko,
  python,
}:

buildPythonPackage rec {
  pname = "scp";
  version = "0.16.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PysmC/m9TCtoV/aXodfo7cJvpWkoK3cCfoSd/h5IWAo=";
  };

  build-system = [ setuptools ];

  propagatedBuildInputs = [ paramiko ];

  checkPhase = ''
    SCPPY_PORT=10022 ${python.interpreter} test.py
  '';

  #The Pypi package doesn't include the test
  doCheck = false;

  pythonImportsCheck = [ "scp" ];

  meta = {
    homepage = "https://github.com/jbardin/scp.py";
    description = "SCP module for paramiko";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ xnaveira ];
  };
}
