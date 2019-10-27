{ stdenv
, buildPythonPackage
, fetchPypi
, six
, isodate
, pyparsing
, html5lib
, keepalive
}:

buildPythonPackage rec {
  pname = "SPARQLWrapper";
  version = "1.8.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "21928e7a97f565e772cdeeb0abad428960f4307e3a13dbdd8f6d3da8a6a506c9";
  };

  # break circular dependency loop
  patchPhase = ''
    sed -i '/rdflib/d' requirements.txt
  '';

  # Doesn't actually run tests
  doCheck = false;

  propagatedBuildInputs = [ six isodate pyparsing html5lib keepalive ];

  meta = with stdenv.lib; {
    description = "This is a wrapper around a SPARQL service. It helps in creating the query URI and, possibly, convert the result into a more manageable format";
    homepage = "http://rdflib.github.io/sparqlwrapper";
    license = licenses.w3c;
  };
}
