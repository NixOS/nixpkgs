{
  lib,
  buildPythonPackage,
  deepmerge,
  fetchPypi,
  setuptools,
  setuptools-scm,
  jsonschema,
  picobox,
  pyyaml,
  sphinx-mdinclude,
  sphinxcontrib-httpdomain,
}:

buildPythonPackage (finalAttrs: {
  pname = "sphinxcontrib-openapi";
  version = "0.8.4";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-34g4CKW15LQROtaXGFxDo/Qt89znBFOveLpwdpB+miA=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    deepmerge
    jsonschema
    picobox
    pyyaml
    sphinx-mdinclude
    sphinxcontrib-httpdomain
  ];

  doCheck = false;

  pythonNamespaces = [ "sphinxcontrib" ];

  pythonImportsCheck = [ "sphinxcontrib.openapi" ];

  meta = {
    homepage = "https://github.com/ikalnytskyi/sphinxcontrib-openapi";
    description = "OpenAPI (fka Swagger) spec renderer for Sphinx";
    license = lib.licenses.bsd0;
    maintainers = [ lib.maintainers.flokli ];
  };
})
