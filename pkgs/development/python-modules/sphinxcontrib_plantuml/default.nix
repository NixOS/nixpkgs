{ lib, stdenv
, buildPythonPackage
, fetchPypi
, sphinx
, plantuml
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-plantuml";
  version = "0.19";

  src = fetchPypi {
    inherit pname version;
    sha256 = "98b9f02282907b0c5b7a93a446c4649909aaf5785d2da0dd263c8ad68e00e288";
  };

  # No tests included.
  doCheck = false;

  propagatedBuildInputs = [ sphinx plantuml ];

  meta = with lib; {
    description = "Provides a Sphinx domain for embedding UML diagram with PlantUML";
    homepage = "https://github.com/sphinx-contrib/plantuml/";
    license = with licenses; [ bsd2 ];
  };

}
