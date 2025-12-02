{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-regex";
  version = "2025.11.3.20251106";
  pyproject = true;

  src = fetchPypi {
    pname = "types_regex";
    inherit version;
    hash = "sha256-X5go7TmlpScntjf5P38PkJ1W+iIRYE7MIT/Ou1CbnVA=";
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
