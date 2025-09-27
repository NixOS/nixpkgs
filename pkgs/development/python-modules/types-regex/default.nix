{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-regex";
  version = "2025.9.18.20250921";
  pyproject = true;

  src = fetchPypi {
    pname = "types_regex";
    inherit version;
    hash = "sha256-4XAMIbHDEpDkpt1iWE7R8dadcE7RZ2toqO2i0dJCDD8=";
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
