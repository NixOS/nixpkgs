{ stdenv, buildPythonPackage, fetchPypi, nose }:

buildPythonPackage rec {
  pname = "voluptuous";
  version = "0.11.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0mplkcpb5d8wjf8vk195fys4y6a3wbibiyf708imw33lphfk9g1a";
  };

  checkInputs = [ nose ];

  meta = with stdenv.lib; {
    description = "Voluptuous is a Python data validation library";
    homepage = "http://alecthomas.github.io/voluptuous/";
    license = licenses.bsd3;
  };
}
