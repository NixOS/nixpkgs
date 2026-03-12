{
  lib,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "securetar";
  version = "2025.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "securetar";
    tag = version;
    hash = "sha256-uVzyVgS8bWxS7jhwVyv7wTNF8REW+dJIhkRaS/8/FmY=";
  };

  build-system = [ setuptools ];

  dependencies = [ cryptography ];

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
