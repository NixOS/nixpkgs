{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  zope-interface,
  zope-proxy,
  zope-schema,
  zope-component,
  zope-configuration,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "zope-location";
  version = "5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "zope.location";
    tag = version;
    hash = "sha256-C8tQ4qqzkQx+iU+Pm3iCEchtqOZT/qcYFSzJWzqlhnI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    zope-interface
    zope-proxy
    zope-schema
  ];

  optional-dependencies = {
    zcml = [ zope-configuration ];
    component = [ zope-component ];
  };

  pythonImportsCheck = [ "zope.location" ];

  nativeCheckInputs = [ unittestCheckHook ];

  # prevent cirtular import
  preCheck = ''
    rm src/zope/location/tests/test_configure.py
    rm src/zope/location/tests/test_pickling.py
  '';

  unittestFlagsArray = [ "src/zope/location/tests" ];

  pythonNamespaces = [ "zope" ];

  meta = {
    homepage = "https://github.com/zopefoundation/zope.location/";
    description = "Zope Location";
    changelog = "https://github.com/zopefoundation/zope.location/blob/${src.tag}/CHANGES.rst";
    license = lib.licenses.zpl21;
    maintainers = [ ];
  };
}
