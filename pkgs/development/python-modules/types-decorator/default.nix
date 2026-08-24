{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "types-decorator";
  version = "5.2.0.20260712";
  pyproject = true;

  src = fetchPypi {
    pname = "types_decorator";
    inherit (finalAttrs) version;
    hash = "sha256-KJDwX+PGVUa69QAP1fHu1NHJW65VFuI+FzW3taTdmMY=";
  };

  build-system = [ setuptools ];

  # Modules doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "decorator-stubs" ];

  meta = {
    description = "Typing stubs for decorator";
    homepage = "https://github.com/python/typeshed";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
