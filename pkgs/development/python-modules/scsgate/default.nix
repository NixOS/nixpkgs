{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyserial,
  pyyaml,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "scsgate";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "flavio";
    repo = "scsgate";
    tag = version;
    hash = "sha256-wVzXKOKljENAKppod+guqm+0XMPenLgOsZzMQVTBo+k=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyserial
    pyyaml
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "scsgate" ];

  meta = {
    description = "Python module to interact with SCSGate";
    homepage = "https://github.com/flavio/scsgate";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
