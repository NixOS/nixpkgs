{ stdenv
, buildPythonPackage
, fetchPypi
, sphinx
, plantuml
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-plantuml";
  version = "0.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "95a453e1d912bfdd6a950f8df02f46608154676842d66f8a0d1db0b85a5ddfe5";
  };

  # No tests included.
  doCheck = false;

  propagatedBuildInputs = [ sphinx plantuml ];

  meta = with stdenv.lib; {
    description = "Provides a Sphinx domain for embedding UML diagram with PlantUML";
    homepage = https://bitbucket.org/birkenfeld/sphinx-contrib;
    license = with licenses; [ bsd2 ];
  };

}
