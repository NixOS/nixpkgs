{
  lib,
  blockdiag,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  seqdiag,
  sphinx,
}:

buildPythonPackage (finalAttrs: {
  pname = "sphinxcontrib-seqdiag";
  version = "3.0.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-QH5IeXZz9x2Ujp/6BHFsrB2ZqeyPYW3jdk1C0DNBZXQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    blockdiag
    seqdiag
    sphinx
  ];

  pythonImportsCheck = [ "sphinxcontrib.seqdiag" ];

  pythonNamespaces = [ "sphinxcontrib" ];

  meta = {
    description = "Sphinx seqdiag extension";
    homepage = "https://github.com/blockdiag/sphinxcontrib-seqdiag";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
})
