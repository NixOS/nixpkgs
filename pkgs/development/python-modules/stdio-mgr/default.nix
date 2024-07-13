{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  attrs,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "stdio-mgr";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bskinn";
    repo = "stdio-mgr";
    rev = "refs/tags/v${version}";
    hash = "sha256-LLp4AmUfuYUX/gHK7Qwge1ib3DBsmxdhFybIo9M5ZnU=";
  };

  build-system = [ setuptools ];

  dependencies = [ attrs ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # README test failed
    "README.rst"
  ];

  pythonImportsCheck = [ "stdio_mgr" ];

  meta = {
    description = "Context manager for mocking/wrapping stdin/stdout/stderr";
    homepage = "https://www.github.com/bskinn/stdio-mgr";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ moraxyc ];
  };
}
