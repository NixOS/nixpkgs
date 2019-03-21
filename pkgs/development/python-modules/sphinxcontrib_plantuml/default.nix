{ stdenv
, buildPythonPackage
, fetchPypi
, sphinx
, plantuml
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-plantuml";
  version = "0.14";

  src = fetchPypi {
    inherit pname version;
    sha256 = "504229e943e8ac821cd9d708124bde30041ae9d8341f9ea953866404527f4e82";
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
