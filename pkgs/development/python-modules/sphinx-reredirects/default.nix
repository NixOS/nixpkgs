{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,
  sphinx,
}:

buildPythonPackage rec {
  pname = "sphinx-reredirects";
  version = "1.0.0";
  pyproject = true;

  src = fetchPypi {
    pname = "sphinx_reredirects";
    inherit version;
    hash = "sha256-fJutqfEzBIn89Mcpei1toqScpId9P0LROIrh3hAZv1w=";
  };

  build-system = [
    flit-core
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
    maintainers = [ ];
  };
}
