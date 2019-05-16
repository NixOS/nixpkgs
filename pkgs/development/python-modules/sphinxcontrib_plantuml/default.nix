{ stdenv
, buildPythonPackage
, fetchPypi
, sphinx
, plantuml
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-plantuml";
  version = "0.15";

  src = fetchPypi {
    inherit pname version;
    sha256 = "06yl6aiw8gpq3wmi6wxy5lahfgbbmlw6nchq9h1ssi5lipwaxn7a";
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
