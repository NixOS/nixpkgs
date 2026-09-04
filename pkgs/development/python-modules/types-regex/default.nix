{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "types-regex";
  version = "2026.8.31.20260901";
  pyproject = true;

  src = fetchPypi {
    pname = "types_regex";
    inherit (finalAttrs) version;
    hash = "sha256-8zVVCEWKP3MbdRHtlNr2fg/Y3prGk4Y7t0CaGSSLsmY=";
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
