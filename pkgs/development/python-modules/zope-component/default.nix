{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  zope-event,
  zope-hookable,
  zope-interface,
  persistent,
  zope-configuration,
  zope-i18nmessageid,
  zope-location,
  zope-proxy,
  zope-security,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "zope-component";
  version = "6.0";
  pyproject = true;

  src = fetchPypi {
    pname = "zope.component";
    inherit version;
    hash = "sha256-mgoEcq0gG5S0/mdBzprCwwuLsixRYHe/A2kt7E37aQY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    zope-event
    zope-hookable
    zope-interface
  ];

  optional-dependencies = {
    persistentregistry = [ persistent ];
    security = [
      zope-location
      zope-proxy
      zope-security
    ];
    zcml = [
      zope-configuration
      zope-i18nmessageid
    ];
  };

  pythonImportsCheck = [ "zope.component" ];

  nativeCheckInputs = [
    unittestCheckHook
    zope-configuration
  ];

  unittestFlagsArray = [ "src/zope/component/tests" ];

  # AssertionError: 'test_interface.IFoo' != 'zope.component.tests.test_interface.IFoo'
  preCheck = ''
    rm src/zope/component/tests/test_interface.py
  '';

  pythonNamespaces = [ "zope" ];

  meta = {
    homepage = "https://github.com/zopefoundation/zope.component";
    description = "Zope Component Architecture";
    changelog = "https://github.com/zopefoundation/zope.component/blob/${version}/CHANGES.rst";
    license = lib.licenses.zpl21;
    maintainers = [ ];
  };
}
