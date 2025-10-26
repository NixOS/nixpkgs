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
  version = "8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "zope.schema";
    tag = version;
    hash = "sha256-qZ7OWpDTBV/wT3FZBUhe6D4olCTBaYkilj+JSwjHKOU=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools ==" "setuptools >="
  '';

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
