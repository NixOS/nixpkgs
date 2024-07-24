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
  version = "2024.2.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "pvizeli";
    repo = "securetar";
    rev = "refs/tags/${version}";
    hash = "sha256-D50ceRlK+v5Uo3qBBpVtKwI8zKU/qh1Njn3qeKM4LiY=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ cryptography ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "securetar" ];

  meta = with lib; {
    description = "Module to handle tarfile backups";
    homepage = "https://github.com/pvizeli/securetar";
    changelog = "https://github.com/pvizeli/securetar/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
