{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-regex";
  version = "2025.10.23.20251023";
  pyproject = true;

  src = fetchPypi {
    pname = "types_regex";
    inherit version;
    hash = "sha256-dfAjvwrwV+AVennpnmZpBTe+uzXZA9uPKbTlwtO+54I=";
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
