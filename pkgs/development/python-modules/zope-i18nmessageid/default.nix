{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "zope-i18nmessageid";
  version = "8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "zope.i18nmessageid";
    tag = version;
    hash = "sha256-lMHmKWwR9D9HW+paV1mDVAirOe0wBD8VrJ67NZoROtg=";
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
    changelog = "https://github.com/zopefoundation/zope.i18nmessageid/blob/${version}/CHANGES.rst";
    license = lib.licenses.zpl21;
    maintainers = [ ];
  };
}
