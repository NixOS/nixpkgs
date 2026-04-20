{
  lib,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  pynacl,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "securetar";
  version = "2026.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "securetar";
    tag = version;
    hash = "sha256-y2Ow272094Qrn52LGYkuRcjaR6d0C6bF12g7W6AwSMI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cryptography
    pynacl
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "securetar" ];

  meta = {
    description = "Module to handle tarfile backups";
    homepage = "https://github.com/home-assistant-libs/securetar";
    changelog = "https://github.com/home-assistant-libs/securetar/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
