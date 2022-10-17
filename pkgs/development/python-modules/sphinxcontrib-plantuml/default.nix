{ lib
, buildPythonPackage
, fetchPypi
, sphinx
, plantuml
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-plantuml";
  version = "0.24";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-z2Xbc1j3haZJjuA+cZi2aAxiXSjlWzNHX8P2yUNRRR0=";
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
