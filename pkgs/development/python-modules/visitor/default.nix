{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "visitor";
  version = "0.1.3";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-LHN5A7K2hk68YWfu9887mXEm8aqUvfWQ+Q8UNtI+SAo=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "visitor" ];

  meta = {
    homepage = "https://github.com/mbr/visitor";
    description = "Tiny pythonic visitor implementation";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
