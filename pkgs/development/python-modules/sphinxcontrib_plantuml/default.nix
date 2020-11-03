{ stdenv
, buildPythonPackage
, fetchPypi
, sphinx
, plantuml
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-plantuml";
  version = "0.18.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c69662d39e4ae214943d8c141dbfb1cf0a5f125d3b45d2c90849c5f37d0c5fb7";
  };

  # No tests included.
  doCheck = false;

  requiredPythonModules = [ sphinx plantuml ];

  meta = with stdenv.lib; {
    description = "Provides a Sphinx domain for embedding UML diagram with PlantUML";
    homepage = "https://github.com/sphinx-contrib/plantuml/";
    license = with licenses; [ bsd2 ];
  };

}
