{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  httpx,
  setuptools,
}:

buildPythonPackage rec {
  pname = "whodap";
  version = "0.1.14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pogzyb";
    repo = "whodap";
    tag = "v${version}";
    hash = "sha256-VSFtHjdG9pJAryGUgwI0NxxaW0JiXEHU7aVvXYxymtc=";
  };

  build-system = [ setuptools ];

  dependencies = [ httpx ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Requires network access
    "tests/test_client.py"
  ];

  pythonImportsCheck = [ "whodap" ];

  meta = {
    description = "Python RDAP utility for querying and parsing information about domain names";
    homepage = "https://github.com/pogzyb/whodap";
    changelog = "https://github.com/pogzyb/whodap/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
