{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pytest-asyncio,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "throttler";
  version = "1.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "uburuntu";
    repo = "throttler";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zcKhHA1PDEpfp+I/zHaGeg1x1F2LM0m7GxMLGDscCsw=";
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
    changelog = "https://github.com/uburuntu/throttler/releases/tag/${finalAttrs.src.tag}";
    description = "Zero-dependency Python package for easy throttling with asyncio support";
    homepage = "https://github.com/uburuntu/throttler";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ renatoGarcia ];
  };
})
