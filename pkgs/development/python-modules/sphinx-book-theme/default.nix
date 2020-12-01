{ lib
, buildPythonPackage
, fetchPypi
, pyyaml
, docutils
, sphinx
, click
, pydata-sphinx-theme
, beautifulsoup4
, importlib-resources
, pythonOlder
}:

buildPythonPackage rec {
  pname = "sphinx-book-theme";
  version = "0.0.39";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "07f9651233cb8ad4f5bde2b88205597622c6ef57c4d9f8799e93999e7ac4f070";
  };

  propagatedBuildInputs = [
    pyyaml
    docutils
    sphinx
    click
    pydata-sphinx-theme
    beautifulsoup4
    importlib-resources
  ];

  meta = with lib; {
    description = "Jupyter Book: Create an online book with Jupyter Notebooks";
    homepage = https://jupyterbook.org/;
    license = licenses.mit;
  };
}