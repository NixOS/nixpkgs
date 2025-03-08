{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  zope-i18nmessageid,
  zope-interface,
  unittestCheckHook,
  zope-component,
  zope-security,
}:

buildPythonPackage rec {
  pname = "zope-size";
  version = "5.0";
  pyproject = true;

  src = fetchPypi {
    pname = "zope.size";
    inherit version;
    hash = "sha256-sVRT40+Bb/VFmtg82TUCmqWBxqRTRj4DxeLZe9IKQyo=";
  };

  build-system = [ setuptools ];

  dependencies = [
    zope-i18nmessageid
    zope-interface
  ];

  pythonImportsCheck = [ "zope.size" ];

  nativeCheckInputs = [
    unittestCheckHook
    zope-component
    zope-security
  ];

  unittestFlagsArray = [ "src/zope/size" ];

  pythonNamespaces = [ "zope" ];

  meta = {
    homepage = "https://github.com/zopefoundation/zope.size";
    description = "Interfaces and simple adapter that give the size of an object";
    changelog = "https://github.com/zopefoundation/zope.size/blob/${version}/CHANGES.rst";
    license = lib.licenses.zpl21;
    maintainers = [ ];
  };
}
