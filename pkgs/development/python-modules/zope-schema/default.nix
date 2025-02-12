{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  zope-event,
  zope-interface,
  unittestCheckHook,
  zope-i18nmessageid,
}:

buildPythonPackage rec {
  pname = "zope-schema";
  version = "7.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "zope.schema";
    tag = version;
    hash = "sha256-aUjlSgMfoKQdE0ta8jxNjh+L7OKkfOVvUWnvhx+QRsI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    zope-event
    zope-interface
  ];

  pythonImportsCheck = [ "zope.schema" ];

  nativeCheckInputs = [
    unittestCheckHook
    zope-i18nmessageid
  ];

  unittestFlagsArray = [ "src/zope/schema/tests" ];

  pythonNamespaces = [ "zope" ];

  meta = {
    homepage = "https://github.com/zopefoundation/zope.schema";
    description = "zope.interface extension for defining data schemas";
    changelog = "https://github.com/zopefoundation/zope.schema/blob/${src.tag}/CHANGES.rst";
    license = lib.licenses.zpl21;
    maintainers = [ ];
  };
}
