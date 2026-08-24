{
  lib,
  buildPythonPackage,
  deepmerge,
  fetchFromGitHub,
  jsonschema,
  picobox,
  pyyaml,
  setuptools-scm,
  setuptools,
  sphinx-mdinclude,
  sphinx,
  sphinxcontrib-httpdomain,
}:

buildPythonPackage (finalAttrs: {
  pname = "sphinxcontrib-openapi";
  version = "0.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sphinx-contrib";
    repo = "openapi";
    tag = finalAttrs.version;
    hash = "sha256-PmT2GcOvO7KmWwjdqkuZ9cgoIZwbg82V21Opsfhz+mY=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  buildInput = [ sphinx ];

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

  meta = {
    description = "OpenAPI (fka Swagger) spec renderer for Sphinx";
    homepage = "https://github.com/ikalnytskyi/sphinxcontrib-openapi";
    changelog = "https://github.com/sphinx-contrib/openapi/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd0;
    maintainers = [ lib.maintainers.flokli ];
  };
})
