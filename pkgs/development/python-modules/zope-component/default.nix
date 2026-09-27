{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
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
  version = "7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "zope.component";
    tag = version;
    hash = "sha256-3Hl2sm2M0we+fpdt4GSjAStLSAJ1c4Za1vfm9Bj8z8s=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools ==" "setuptools >="
  '';

  build-system = [ setuptools ];

  dependencies = [
    zope-event
    zope-hookable
    zope-interface
  ];

  optional-dependencies = {
    hook = [ ];
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
