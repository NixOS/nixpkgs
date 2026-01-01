{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,
  sphinx,
}:

buildPythonPackage rec {
  pname = "sphinx-reredirects";
<<<<<<< HEAD
  version = "1.1.0";
=======
  version = "1.0.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchPypi {
    pname = "sphinx_reredirects";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-+5sZUzWrFLQ/gnMofQx+62N7psVsZlgcEbRyAvZxiyk=";
=======
    hash = "sha256-fJutqfEzBIn89Mcpei1toqScpId9P0LROIrh3hAZv1w=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
