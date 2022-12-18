{ lib
, buildPythonPackage
, fetchPypi
, sphinx
, plantuml
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-plantuml";
  version = "0.24.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-OdLkvEDV4JMSYSmhRPVrbuFfWM+lBItZSOY6Ea/ztYY=";
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
