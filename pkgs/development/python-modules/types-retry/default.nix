{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "types-retry";
  version = "0.9.9.20260408";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "types_retry";
    inherit (finalAttrs) version;
    hash = "sha256-P5j6YuwCdEk4P1wBnM6sx4TB26tHYJid2rQh97hAfZI=";
  };

  build-system = [ setuptools ];

  # Modules doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "retry-stubs" ];

  meta = {
    description = "Typing stubs for retry";
    homepage = "https://github.com/python/typeshed";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
