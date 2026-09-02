{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  sphinx,
  mscgen,
}:

buildPythonPackage (finalAttrs: {
  pname = "sphinxcontrib-mscgen";
  version = "0.6";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-AXfSWRq3CepT/jNOgHxiYT7vkdKZejPu/LeUqxZ8T5A=";
  };

  build-system = [ setuptools ];

  dependencies = [
    mscgen
    sphinx
  ];

  # There are no unit tests
  doCheck = false;

  pythonImportsCheck = [ "sphinxcontrib.mscgen" ];

  pythonNamespaces = [ "sphinxcontrib" ];

  meta = {
    description = "Sphinx extension using mscgen to render diagrams";
    homepage = "https://github.com/sphinx-contrib/mscgen";
    license = lib.licenses.bola11;
    maintainers = [ ];
  };
})
