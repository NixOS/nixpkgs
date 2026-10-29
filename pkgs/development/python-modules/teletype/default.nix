{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "teletype";
  version = "1.3.4";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-uBppM4w9GlMgYqKFGw1Rcjvq+mnU04K3E74jCgK9YYo=";
  };

  nativeBuildInputs = [ setuptools ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "teletype" ];

  meta = {
    description = "High-level cross platform tty library";
    homepage = "https://github.com/jkwill87/teletype";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
