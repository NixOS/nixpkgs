{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "types-regex";
  version = "2026.2.19.20260221";
  pyproject = true;

  src = fetchPypi {
    pname = "types_regex";
    inherit (finalAttrs) version;
    hash = "sha256-u+fQHX/c3O2nu+Kz4TUL556ddY9h+YqnsEgczFXOZ8s=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "regex-stubs" ];

  # Module has no tests
  doCheck = false;

  meta = {
    description = "Typing stubs for regex";
    homepage = "https://github.com/python/typeshed";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dwoffinden ];
  };
})
