{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:
buildPythonPackage (finalAttrs: {
  pname = "types-openpyxl";
  version = "3.1.5.20250919";

  pyproject = true;

  src = fetchPypi {
    pname = "types_openpyxl";
    inherit (finalAttrs) version;
    hash = "sha256-IytZBnc+66zhUJuJlM2t2gQ/aSz9upv7uGypIdVNMtc=";
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
