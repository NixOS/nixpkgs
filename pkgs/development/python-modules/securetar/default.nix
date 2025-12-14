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
  version = "2025.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pvizeli";
    repo = "securetar";
    tag = version;
    hash = "sha256-wCm4WBuzkqYWDGoyDyML1tdUyOdT2hy/qFk2DU4h/tQ=";
  };

  build-system = [ setuptools ];

  dependencies = [ cryptography ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "securetar" ];

  meta = {
    description = "Module to handle tarfile backups";
    homepage = "https://github.com/pvizeli/securetar";
    changelog = "https://github.com/pvizeli/securetar/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
