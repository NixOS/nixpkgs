{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  sphinx,
  plantuml,
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-plantuml";
  version = "0.31";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/XR1L46gcOZBw/ikAvzPodSkBW4JZ7VgM9KnYoLZ+VY=";
  };

  build-system = [ setuptools ];

  dependencies = [ sphinx ];

  propagatedBuildInputs = [ plantuml ];

  pythonImportsCheck = [ "sphinxcontrib.plantuml" ];

  # No tests included.
  doCheck = false;

  pythonNamespaces = [ "sphinxcontrib" ];

  meta = {
    description = "Provides a Sphinx domain for embedding UML diagram with PlantUML";
    homepage = "https://github.com/sphinx-contrib/plantuml/";
    license = with lib.licenses; [ bsd2 ];
    maintainers = [ ];
  };
}
