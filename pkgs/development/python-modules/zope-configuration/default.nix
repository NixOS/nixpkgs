{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,
  setuptools,
  zope-i18nmessageid,
  zope-interface,
  zope-schema,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "zope-configuration";
  version = "6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "zope.configuration";
    tag = version;
    hash = "sha256-dkEVIHaXk/oP4uYYzI1hgSnPZXBMDjDu97zmOXnj9NA=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools < 74" "setuptools"
  '';

  build-system = [ setuptools ];

  dependencies = [
    zope-i18nmessageid
    zope-interface
    zope-schema
  ];

  pythonImportsCheck = [ "zope.configuration" ];

  nativeCheckInputs = [ unittestCheckHook ];

  preCheck = ''
    cd $out/${python.sitePackages}/zope/
  '';

  unittestFlagsArray = [ "configuration/tests" ];

  pythonNamespaces = [ "zope" ];

  meta = with lib; {
    description = "Zope Configuration Markup Language (ZCML)";
    homepage = "https://github.com/zopefoundation/zope.configuration";
    changelog = "https://github.com/zopefoundation/zope.configuration/blob/${version}/CHANGES.rst";
    license = licenses.zpl21;
    maintainers = [ ];
  };
}
