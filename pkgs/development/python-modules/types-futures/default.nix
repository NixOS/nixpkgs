{
  buildPythonPackage,
  fetchPypi,
  lib,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "types-futures";
  version = "3.3.8";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-b+jMwsKvfvL92b9z6rbWFwdPCfMK19NzUQtAQ9OcQt4=";
  };

  build-system = [ setuptools ];

  meta = {
    description = "Typing stubs for futures";
    homepage = "https://github.com/python/typeshed";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ andersk ];
  };
})
