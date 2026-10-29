{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "udsoncan";
  version = "1.26.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "pylessard";
    repo = "python-udsoncan";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zprGzcSPfDcP9RKtWmXhQTYT8eR2NQFyfKggRBaIfUU=";
  };

  build-system = [
    setuptools
  ];

  # test/test_connection.py binds a socket on 127.0.0.1
  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "udsoncan"
  ];

  meta = {
    description = "Python implementation of UDS (ISO-14229) standard";
    homepage = "https://github.com/pylessard/python-udsoncan";
    changelog = "https://github.com/pylessard/python-udsoncan/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ WOnder93 ];
  };
})
