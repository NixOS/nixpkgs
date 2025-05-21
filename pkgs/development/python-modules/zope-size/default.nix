{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  zope-i18nmessageid,
  zope-interface,
  unittestCheckHook,
  zope-component,
  zope-configuration,
  zope-security,
}:

buildPythonPackage rec {
  pname = "zope-size";
  version = "5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "zope.size";
    tag = version;
    hash = "sha256-9r7l3RgE9gvxJ2I5rFvNn/XIztecXW3GseGeM3MzfTU=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools <= 75.6.0" setuptools
  '';

  build-system = [ setuptools ];

  dependencies = [
    zope-i18nmessageid
    zope-interface
  ];

  pythonImportsCheck = [ "zope.size" ];

  nativeCheckInputs = [
    unittestCheckHook
    zope-component
    zope-configuration
    zope-security
  ];

  unittestFlagsArray = [ "src/zope/size" ];

  pythonNamespaces = [ "zope" ];

  meta = {
    homepage = "https://github.com/zopefoundation/zope.size";
    description = "Interfaces and simple adapter that give the size of an object";
    changelog = "https://github.com/zopefoundation/zope.size/blob/${version}/CHANGES.rst";
    license = lib.licenses.zpl21;
    maintainers = [ ];
  };
}
