{ lib
, buildPythonPackage
, fetchPypi
, sphinx
, plantuml
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-plantuml";
  version = "0.23";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-HVVRjwqG7NbJa6j/jIhK3KBbrD5Y52ppKjzRmqf0Ks8=";
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
