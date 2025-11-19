{
  lib,
  buildPythonPackage,
  fetchPypi,
  mock,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
  twisted,
  zope-interface,
}:

buildPythonPackage rec {
  pname = "txaio";
  version = "25.9.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5CAEoHfALrWBn/AEpJieSdsRODZwhDDVnLE9Mb0wkJk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    twisted
    zope-interface
  ];

  nativeCheckInputs = [
    mock
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # No real value
    "test_sdist"
    # Some tests seems out-dated and require additional data
    "test_as_future"
    "test_errback"
    "test_create_future"
    "test_callback"
    "test_immediate_result"
    "test_cancel"
  ];

  pythonImportsCheck = [ "txaio" ];

  meta = with lib; {
    description = "Utilities to support code that runs unmodified on Twisted and asyncio";
    homepage = "https://github.com/crossbario/txaio";
    changelog = "https://github.com/crossbario/txaio/blob/v${version}/docs/releases.rst";
    license = licenses.mit;
    maintainers = [ ];
  };
}
