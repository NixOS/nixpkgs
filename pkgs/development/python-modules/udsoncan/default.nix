{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  pytestCheckHook,
}:
buildPythonPackage (finalAttrs: {
  pname = "udsoncan";
  version = "1.25.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pylessard";
    repo = "python-udsoncan";
    tag = "v${finalAttrs.version}";
    hash = "sha256-71l4bWuFJEUeNGbNylhQg57mTE2oeuhlwBNVPNNrnIQ=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTestPaths = [
    # PytestUnhandledThreadExceptionWarning: Exception in thread Thread-853
    "test/client"
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "udsoncan" ];

  meta = {
    description = "Implementation of the Unified Diagnostic Services (UDS) protocol defined by ISO-14229";
    homepage = "https://udsoncan.readthedocs.io/en/v${finalAttrs.version}/";
    changelog = "https://github.com/pylessard/python-udsoncan/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      mana-byte
      RossSmyth
    ];
  };
})
