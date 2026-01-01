{
  lib,
  buildPythonPackage,
<<<<<<< HEAD
  fetchFromGitHub,
=======
  fetchPypi,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
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

=======
  version = "6.0";
  pyproject = true;

  src = fetchPypi {
    pname = "zope.component";
    inherit version;
    hash = "sha256-mgoEcq0gG5S0/mdBzprCwwuLsixRYHe/A2kt7E37aQY=";
  };

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  build-system = [ setuptools ];

  dependencies = [
    zope-event
    zope-hookable
    zope-interface
  ];

  optional-dependencies = {
<<<<<<< HEAD
    hook = [ ];
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
