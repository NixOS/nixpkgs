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
  version = "1.8.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7f4c8d38ea1bfcffbc358c9a05de35a3fd7152cc3e8ea57963ee7a0a242f7a5e";
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
