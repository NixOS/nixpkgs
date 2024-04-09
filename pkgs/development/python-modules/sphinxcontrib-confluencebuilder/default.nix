{ lib
, buildPythonPackage
, fetchPypi
, flit-core
, docutils
, sphinx
, requests
, jinja2
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-confluencebuilder";
  version = "2.5.0";
  format = "pyproject";

  src = fetchPypi {
    pname = "sphinxcontrib_confluencebuilder";
    inherit version;
    hash = "sha256-rE9tWUie9ZaeWnKR+ojwS9A6BHEtsgVpwzXAuWoxknQ=";
  };

  nativeBuildInputs = [
    flit-core
  ];

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

  pythonNamespaces = [ "sphinxcontrib" ];

  meta = with lib; {
    description = "Confluence builder for sphinx";
    mainProgram = "sphinx-build-confluence";
    homepage = "https://github.com/sphinx-contrib/confluencebuilder";
    license = licenses.bsd1;
    maintainers = with maintainers; [ graysonhead ];
  };
}
