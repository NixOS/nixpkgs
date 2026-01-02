{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  zope-schema,
  zope-interface,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "zope-filerepresentation";
  version = "7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "zope.filerepresentation";
    tag = version;
    hash = "sha256-VWi00b7m+aKwkg/Gfzo5fJWMqdMqgowBpkqsYcEO2gY=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools ==" "setuptools >="
  '';

  build-system = [ setuptools ];

  dependencies = [
    zope-interface
    zope-schema
  ];

  pythonImportsCheck = [ "zope.filerepresentation" ];

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlagsArray = [ "src/zope/filerepresentation" ];

  pythonNamespaces = [ "zope" ];

  meta = {
    homepage = "https://github.com/zopefoundation/zope.filerepresentation";
    description = "File-system Representation Interfaces";
    changelog = "https://github.com/zopefoundation/zope.filerepresentation/blob/${version}/CHANGES.rst";
    license = lib.licenses.zpl21;
    maintainers = [ ];
  };
}
