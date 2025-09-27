{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-regex";
  version = "2025.9.1.20250903";
  pyproject = true;

  src = fetchPypi {
    pname = "types_regex";
    inherit version;
    hash = "sha256-IwEW9ktcCLBhCdlQCG5V/ICbiipdE+gCGKx880+arIQ=";
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
