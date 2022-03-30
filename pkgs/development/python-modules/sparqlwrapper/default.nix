{ lib
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
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-P+0+vMd2F6SnTSZEuG/Yjg8y5/cAOseyszTAJiAXMfE=";
  };

  # break circular dependency loop
  patchPhase = ''
    sed -i '/rdflib/d' requirements.txt
  '';

  # Doesn't actually run tests
  doCheck = false;

  propagatedBuildInputs = [ six isodate pyparsing html5lib keepalive ];

  meta = with lib; {
    description = "This is a wrapper around a SPARQL service. It helps in creating the query URI and, possibly, convert the result into a more manageable format";
    homepage = "http://rdflib.github.io/sparqlwrapper";
    license = licenses.w3c;
  };
}
