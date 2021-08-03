{ lib
, buildPythonPackage
, fetchPypi
, sphinx
, plantuml
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-plantuml";
  version = "0.21";

  src = fetchPypi {
    inherit pname version;
    sha256 = "53e1808dc2b1f3ec20c177fa3fa6d438d75ef572a25a489e330bb01130508d87";
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
