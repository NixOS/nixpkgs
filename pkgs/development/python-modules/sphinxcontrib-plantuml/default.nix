{
  lib,
  buildPythonPackage,
  fetchPypi,
  sphinx,
  plantuml,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-plantuml";
  version = "0.29";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-l6Tyomr5HbiHcMz4o7LgMwW82n7EGn+Wn8jLJ7hKPEQ=";
  };

  propagatedBuildInputs = [
    sphinx
    plantuml
  ];

  # No tests included.
  doCheck = false;

  pythonNamespaces = [ "sphinxcontrib" ];

  meta = with lib; {
    description = "Provides a Sphinx domain for embedding UML diagram with PlantUML";
    homepage = "https://github.com/sphinx-contrib/plantuml/";
    license = with licenses; [ bsd2 ];
    maintainers = with maintainers; [ ];
  };
}
