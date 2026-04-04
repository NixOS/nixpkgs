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
  version = "2026.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "securetar";
    tag = version;
    hash = "sha256-76JZN0Y9uW0+HUX+j1aCIz9qOjogZ0KXOXXK8rR8Z/4=";
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
