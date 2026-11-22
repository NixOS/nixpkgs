{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:
buildPythonPackage (finalAttrs: {
  pname = "types-openpyxl";
  version = "3.1.5.20261017";

  pyproject = true;

  src = fetchPypi {
    pname = "types_openpyxl";
    inherit (finalAttrs) version;
    hash = "sha256-Pes7Ynm2WrN5wSbfDuH9J1AMlijtuNlmfXP2N0YpF9w=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "openpyxl-stubs" ];

  meta = {
    description = "Typing stubs for openpyxl";
    homepage = "https://github.com/python/typeshed";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.me-and ];
  };
})
