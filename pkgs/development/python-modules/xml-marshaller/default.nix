{
  buildPythonPackage,
  fetchPypi,
  lib,
  setuptools,
  lxml,
  six,
}:

buildPythonPackage (finalAttrs: {
  pname = "xml-marshaller";
  version = "1.0.2";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "xml_marshaller";
    inherit (finalAttrs) version;
    hash = "sha256-QvBALLDD8o5nZQ5Z4bembhadK6jcydWKQpJaSmGqqJM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    lxml
    six
  ];

  pythonImportsCheck = [ "xml_marshaller" ];

  meta = {
    description = "This module allows one to marshal simple Python data types into a custom XML format";
    homepage = "https://www.python.org/community/sigs/current/xml-sig/";
    license = lib.licenses.psfl;
    maintainers = with lib.maintainers; [ mazurel ];
  };
})
