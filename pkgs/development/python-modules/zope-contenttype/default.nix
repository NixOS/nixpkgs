{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  zope-testrunner,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "zope-contenttype";
  version = "5.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "zope.contenttype";
    inherit version;
    hash = "sha256-AAHvG2XKZQUZBW3OUwxY0LOWlXzPBQIyPIoVSdtk0xc=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    zope-testrunner
  ];

  pythonImportsCheck = [ "zope.contenttype" ];

  meta = with lib; {
    homepage = "https://github.com/zopefoundation/zope.contenttype";
    description = "Utility module for content-type (MIME type) handling";
    changelog = "https://github.com/zopefoundation/zope.contenttype/blob/${version}/CHANGES.rst";
    license = licenses.zpl21;
    maintainers = [ ];
  };
}
