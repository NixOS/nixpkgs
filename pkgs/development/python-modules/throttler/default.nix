{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pytest-asyncio,
  setuptools,
}:

buildPythonPackage rec {
  pname = "throttler";
  version = "1.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "uburuntu";
    repo = "throttler";
    tag = "v${version}";
    hash = "sha256-fE35zPjBUn4e1VRkkIUMtYJ/+LbnUxnxyfnU+UEPwr4=";
  };

  build-system = [ setuptools ];

  checkInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  enabledTestPaths = [ "tests/" ];

  disabledTestPaths = [
    # time sensitive tests
    "tests/test_execution_timer.py"
  ];

  meta = {
    changelog = "https://github.com/uburuntu/throttler/releases/tag/${src.tag}";
    description = "Zero-dependency Python package for easy throttling with asyncio support";
    homepage = "https://github.com/uburuntu/throttler";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ renatoGarcia ];
  };
}
