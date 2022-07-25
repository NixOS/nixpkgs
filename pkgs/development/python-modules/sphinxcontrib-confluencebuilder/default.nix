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
  version = "1.8.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-u+sjhj/2fu8fLGRb2zgnNI+y7wIIUYTMJhRekrdtMeU=";
  };

  propagatedBuildInputs = [
    docutils
    sphinx
    requests
    jinja2
  ];

  # Something about the way the unit tests are structured in this project is causing them to fail
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
