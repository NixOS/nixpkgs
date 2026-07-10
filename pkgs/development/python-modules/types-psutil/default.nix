{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "types-psutil";
  version = "7.2.1.20260116";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "types_psutil";
    inherit (finalAttrs) version;
    hash = "sha256-RmG+XV16zV2K+wKpLQUWCmy7LOdHIyRbUfe6ff25+YE=";
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
