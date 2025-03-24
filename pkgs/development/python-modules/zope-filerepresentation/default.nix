{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  zope-schema,
  zope-interface,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "zope-filerepresentation";
  version = "6.0";
  pyproject = true;

  src = fetchPypi {
    pname = "zope.filerepresentation";
    inherit version;
    hash = "sha256-yza3iGspJ2+C8WhfPykfQjXmac2HhdFHQtRl0Trvaqs=";
  };

  build-system = [ setuptools ];

  dependencies = [
    zope-interface
    zope-schema
  ];

  pythonImportsCheck = [ "zope.filerepresentation" ];

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlagsArray = [ "src/zope/filerepresentation" ];

  pythonNamespaces = [ "zope" ];

  meta = {
    homepage = "https://github.com/zopefoundation/zope.filerepresentation";
    description = "File-system Representation Interfaces";
    changelog = "https://github.com/zopefoundation/zope.filerepresentation/blob/${version}/CHANGES.rst";
    license = lib.licenses.zpl21;
    maintainers = [ ];
  };
}
