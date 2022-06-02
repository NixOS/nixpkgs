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
  version = "0.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-k2+qTtxkF0rT5LLPW8icePbf9jNopdo9uDp3NPA9SRo=";
  };

  propagatedBuildInputs = [
    trio
  ];

  checkInputs = [
    pytest-asyncio
    pytestCheckHook
    pytest-trio
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
