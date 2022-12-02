{ lib
, buildPythonPackage
, fetchPypi
, mock
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, twisted
, zope_interface
}:

buildPythonPackage rec {
  pname = "txaio";
  version = "22.2.1";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-LkWCtw8EsjRZCCVGhKmEIGwNm1DjB0okpMVauiHSTQE=";
  };

  propagatedBuildInputs = [
    twisted
    zope_interface
  ];

  checkInputs = [
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
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
