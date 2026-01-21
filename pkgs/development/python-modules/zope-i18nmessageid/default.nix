{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "zope-i18nmessageid";
  version = "8.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "zope.i18nmessageid";
    tag = version;
    hash = "sha256-JDCbk7zh+9Ic5T3Pt1apQDN1Q59cLUdk5KCAIu5mlC4=";
  };

  build-system = [ setuptools ];

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
