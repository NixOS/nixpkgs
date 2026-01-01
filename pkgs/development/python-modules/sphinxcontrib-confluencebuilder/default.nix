{
  lib,
  buildPythonPackage,
  docutils,
  fetchPypi,
  flit-core,
  jinja2,
  pythonOlder,
  requests,
  sphinx,
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-confluencebuilder";
<<<<<<< HEAD
  version = "2.16.0";
=======
  version = "2.14.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "sphinxcontrib_confluencebuilder";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-/DAmVxbqFbEuYp0wpJXL/orw8GMDeDkLrXq2XAHTKOA=";
=======
    hash = "sha256-3XWs1SCb6AJpYC3njbBFXsSOebNjRh0Gp1Fqi5E51lI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ flit-core ];

  dependencies = [
    docutils
    sphinx
    requests
    jinja2
  ];

  # Tests are disabled due to a circular dependency on Sphinx
  doCheck = false;

  pythonImportsCheck = [ "sphinxcontrib.confluencebuilder" ];

  pythonNamespaces = [ "sphinxcontrib" ];

<<<<<<< HEAD
  meta = {
    description = "Confluence builder for sphinx";
    homepage = "https://github.com/sphinx-contrib/confluencebuilder";
    changelog = "https://github.com/sphinx-contrib/confluencebuilder/blob/v${version}/CHANGES.rst";
    license = lib.licenses.bsd1;
    maintainers = with lib.maintainers; [ graysonhead ];
=======
  meta = with lib; {
    description = "Confluence builder for sphinx";
    homepage = "https://github.com/sphinx-contrib/confluencebuilder";
    changelog = "https://github.com/sphinx-contrib/confluencebuilder/blob/v${version}/CHANGES.rst";
    license = licenses.bsd1;
    maintainers = with maintainers; [ graysonhead ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "sphinx-build-confluence";
  };
}
