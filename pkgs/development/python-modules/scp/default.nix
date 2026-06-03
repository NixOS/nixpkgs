{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  paramiko,
  python,
}:

buildPythonPackage (finalAttrs: {
  pname = "scp";
  version = "0.15.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-8bIumTISPM8X7r8Z4JU8bpFI9Yn5PZG4cpQaaWMFyD8=";
  };

  build-system = [ setuptools ];

  dependencies = [ paramiko ];

  checkPhase = ''
    SCPPY_PORT=10022 ${python.interpreter} test.py
  '';

  #The Pypi package doesn't include the test
  doCheck = false;

  pythonImportsCheck = [ "scp" ];

  meta = {
    homepage = "https://github.com/jbardin/scp.py";
    description = "SCP module for paramiko";
    changelog = "https://github.com/jbardin/scp.py/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ xnaveira ];
  };
})
