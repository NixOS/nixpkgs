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
  version = "6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zopefoundation";
    repo = "zope.filerepresentation";
    tag = version;
    hash = "sha256-6J4munk2yyZ6e9rpU2Op+Gbf0OXGI6GpHjmpUZVRjsY=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools <= 75.6.0" setuptools
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
