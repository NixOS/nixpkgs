{ lib
, buildPythonPackage
, fetchPypi
, sphinx
, plantuml
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-plantuml";
  version = "0.22";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a42c7a13ab1ae9ed18e8e8b0f76b8d35dc476fdebe6e634354fe6fd0f261f686";
  };

  # No tests included.
  doCheck = false;

  propagatedBuildInputs = [ sphinx plantuml ];

  meta = with lib; {
    description = "Provides a Sphinx domain for embedding UML diagram with PlantUML";
    homepage = "https://github.com/sphinx-contrib/plantuml/";
    maintainers = with maintainers; [ ];
    license = with licenses; [ bsd2 ];
  };
}
