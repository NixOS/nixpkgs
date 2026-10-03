{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  unittestCheckHook,
  zope-interface,
}:

buildPythonPackage rec {
  pname = "zope-i18nmessageid";
  version = "8.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "zope.i18nmessageid";
    tag = version;
    hash = "sha256-u7hipp3kV+gEAcun08PJIB0GZLeFrWc5Xqns1S/66iI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    zope-interface
  ];

  nativeCheckInputs = [
    unittestCheckHook
  ];

  unittestFlagsArray = [ "src/zope/i18nmessageid" ];

  pythonImportsCheck = [ "zope.i18nmessageid" ];

  pythonNamespaces = [ "zope" ];

  meta = {
    homepage = "https://github.com/zopefoundation/zope.i18nmessageid";
    description = "Message Identifiers for internationalization";
    changelog = "https://github.com/zopefoundation/zope.i18nmessageid/blob/${src.tag}/CHANGES.rst";
    license = lib.licenses.zpl21;
    maintainers = [ ];
  };
}
