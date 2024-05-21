{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "youless-api";
  version = "1.1.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "gjong";
    repo = "youless-python-bridge";
    rev = "refs/tags/${version}";
    hash = "sha256-J3YRRVcA4LYxuJMi//LJO8Qt8hapJruZGzONODE3SsQ=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "youless_api" ];

  meta = with lib; {
    description = "Python library for YouLess sensors";
    homepage = "https://github.com/gjong/youless-python-bridge";
    changelog = "https://github.com/gjong/youless-python-bridge/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
