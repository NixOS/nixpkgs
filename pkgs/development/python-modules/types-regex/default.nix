{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-regex";
  version = "2026.1.15.20260116";
  pyproject = true;

  src = fetchPypi {
    pname = "types_regex";
    inherit version;
    hash = "sha256-cVGpvMW7+ez8z4M1xFGsqCBPWgmS4GIqr69IKHbO5Pc=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [
    "regex-stubs"
  ];

  meta = {
    description = "Typing stubs for regex";
    homepage = "https://github.com/python/typeshed";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dwoffinden ];
  };
}
