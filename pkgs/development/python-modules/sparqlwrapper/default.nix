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
  version = "1.8.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d6a66b5b8cda141660e07aeb00472db077a98d22cb588c973209c7336850fb3c";
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
