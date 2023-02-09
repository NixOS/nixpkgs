{ lib
, buildPythonPackage
, fetchPypi
, pytest-asyncio
, pytest-trio
, pytestCheckHook
, pythonOlder
, trio
}:

buildPythonPackage rec {
  pname = "siosocks";
  version = "0.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-uja79vWhPYOhhTUBIh+XpS4GnrYJy0/XpDXXQjnyHWM=";
  };

  propagatedBuildInputs = [
    trio
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    pytest-trio
  ];

  disabledTests = [
    # network access
    "test_connection_direct_success"
    "test_connection_socks_success"
    "test_connection_socks_failed"
  ];

  disabledTestPaths = [
    # Timeout on Hydra
    "tests/test_trio.py"
    "tests/test_sansio.py"
    "tests/test_socketserver.py"
  ];

  pythonImportsCheck = [
    "siosocks"
  ];

  meta = with lib; {
    description = "Python socks 4/5 client/server library/framework";
    homepage = "https://github.com/pohmelie/siosocks";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
