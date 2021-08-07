{ buildPythonPackage
, fetchPypi
, lib
, lxml
, six
}:

buildPythonPackage rec {
  pname = "xml-marshaller";
  version = "1.0.2";

  src = fetchPypi {
    inherit version;
    pname = "xml_marshaller";
    sha256 = "sha256-QvBALLDD8o5nZQ5Z4bembhadK6jcydWKQpJaSmGqqJM=";
  };

  propagatedBuildInputs = [ lxml six ];

  meta = with lib; {
    description = "This module allows one to marshal simple Python data types into a custom XML format.";
    homepage = "https://www.python.org/community/sigs/current/xml-sig/";
    license = licenses.psfl;
    maintainers = with maintainers; [ mazurel ];
  };
}
