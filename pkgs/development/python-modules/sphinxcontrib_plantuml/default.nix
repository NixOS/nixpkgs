{ stdenv
, buildPythonPackage
, fetchPypi
, sphinx
, plantuml
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-plantuml";
  version = "0.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "011yprqf41dcm1824zgk2w8vi9115286pmli6apwhlrsxc6b6cwv";
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
