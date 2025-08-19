{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  zope-testrunner,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "zope-i18nmessageid";
  version = "7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "zope.i18nmessageid";
    tag = version;
    hash = "sha256-rdTs1pNMKpPAR2CewXdg1KmI61Sw5r62OobYlJHsUaQ=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools<74" "setuptools"
  '';

  build-system = [ setuptools ];

  nativeCheckInputs = [
    unittestCheckHook
    zope-testrunner
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
