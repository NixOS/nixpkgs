{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  zope-event,
  zope-interface,
  unittestCheckHook,
  zope-component,
  zope-testing,
}:

buildPythonPackage rec {
  pname = "zope-lifecycleevent";
  version = "5.0";
  pyproject = true;

  src = fetchPypi {
    pname = "zope.lifecycleevent";
    inherit version;
    hash = "sha256-6tP7SW52FPm1adFtrUt4BSsKwhh1utjWbKNQNS2bb50=";
  };

  build-system = [ setuptools ];

  dependencies = [
    zope-event
    zope-interface
  ];

  pythonImportsCheck = [
    "zope.lifecycleevent"
    "zope.interface"
  ];

  nativeCheckInputs = [
    unittestCheckHook
    zope-component
    zope-testing
  ];

  unittestFlagsArray = [ "src/zope/lifecycleevent" ];

  pythonNamespaces = [ "zope" ];

  meta = {
    homepage = "https://github.com/zopefoundation/zope.lifecycleevent";
    description = "Object life-cycle events";
    changelog = "https://github.com/zopefoundation/zope.lifecycleevent/blob/${version}/CHANGES.rst";
    license = lib.licenses.zpl21;
    maintainers = [ ];
  };
}
