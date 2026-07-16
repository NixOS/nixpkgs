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
  version = "6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "zope.size";
    tag = version;
    hash = "sha256-jjI9NvfxnIWZrqDEpZ6FDlhDWZoqEUBliiyh+5PxOAg=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools ==" "setuptools >="
  '';

  build-system = [ setuptools ];

  dependencies = [
    zope-i18nmessageid
    zope-interface
  ];

  optional-dependencies = {
    zcml = [
      zope-component
      zope-configuration
      zope-security
    ]
    ++ zope-component.optional-dependencies.zcml
    ++ zope-security.optional-dependencies.zcml;
  };

  pythonImportsCheck = [ "zope.size" ];

  nativeCheckInputs = [
    unittestCheckHook
  ]
  ++ lib.concatAttrValues optional-dependencies;

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
