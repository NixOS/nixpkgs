{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "zope-contenttype";
  version = "5.1";
  pyproject = true;

  src = fetchPypi {
    pname = "zope.contenttype";
    inherit version;
    hash = "sha256-AAHvG2XKZQUZBW3OUwxY0LOWlXzPBQIyPIoVSdtk0xc=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "zope.contenttype" ];

  pythonNamespaces = [ "zope" ];

  meta = {
    homepage = "https://github.com/zopefoundation/zope.contenttype";
    description = "Utility module for content-type (MIME type) handling";
    changelog = "https://github.com/zopefoundation/zope.contenttype/blob/${version}/CHANGES.rst";
    license = lib.licenses.zpl21;
    maintainers = [ ];
  };
}
