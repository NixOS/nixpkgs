{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "types-psutil";
  version = "7.2.2.20260518";
  pyproject = true;

  src = fetchPypi {
    pname = "types_psutil";
    inherit (finalAttrs) version;
    hash = "sha256-n4JfYxRjpbTSbxn2OuvJ7CXwEUDWVQJvOtimeEH5szE=";
  };

  build-system = [ setuptools ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "psutil-stubs" ];

  meta = {
    description = "Typing stubs for psutil";
    homepage = "https://github.com/python/typeshed";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
