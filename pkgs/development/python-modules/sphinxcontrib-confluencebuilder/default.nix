{ lib
, buildPythonPackage
, fetchPypi
, docutils
, sphinx
, requests
, jinja2
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-confluencebuilder";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-RyShQt/t8tnE5ZHM0WDQ+jrvXem3y24tCpj3s6Thq+g=";
  };

  propagatedBuildInputs = [
    docutils
    sphinx
    requests
    jinja2
  ];

  # Tests are disabled due to a circular dependency on Sphinx
  doCheck = false;

  pythonImportsCheck = [
    "sphinxcontrib.confluencebuilder"
  ];

  meta = with lib; {
    description = "Confluence builder for sphinx";
    homepage = "https://github.com/sphinx-contrib/confluencebuilder";
    license = licenses.bsd1;
    maintainers = with maintainers; [ graysonhead ];
  };
}
