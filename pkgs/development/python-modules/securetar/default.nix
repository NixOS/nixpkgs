{
  lib,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "securetar";
  version = "2025.1.4";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "pvizeli";
    repo = "securetar";
    tag = version;
    hash = "sha256-vI9u8CUf9rdJwx+Q3ypO9XS/jfRxZV5EOjvKSmQSNa0=";
  };

  build-system = [ setuptools ];

  dependencies = [ cryptography ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "securetar" ];

  meta = with lib; {
    description = "Module to handle tarfile backups";
    homepage = "https://github.com/pvizeli/securetar";
    changelog = "https://github.com/pvizeli/securetar/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
