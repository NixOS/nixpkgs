{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  sphinx,
}:

buildPythonPackage rec {
  pname = "sphinx-reredirects";
  version = "0.1.6";
  pyproject = true;

  src = fetchPypi {
    pname = "sphinx_reredirects";
    inherit version;
    hash = "sha256-xJHLpUX2e+lpdQhyeBjYYmYmNmJFrmRFb+KfN+m76mQ=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    sphinx
  ];

  pythonImportsCheck = [
    "sphinx_reredirects"
  ];

  meta = {
    description = "Handles redirects for moved pages in Sphinx documentation projects";
    homepage = "https://pypi.org/project/sphinx-reredirects";
    license = with lib.licenses; [
      bsd3
      mit
    ];
    maintainers = with lib.maintainers; [ ];
  };
}
