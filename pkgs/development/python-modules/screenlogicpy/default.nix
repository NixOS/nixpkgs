{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "screenlogicpy";
  version = "0.5.5";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "dieselrabbit";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-1tBr7k7RutCHvea/56J7drl9P+WZ5bQpDeQwhgktc1s=";
  };

  checkInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # Tests require network access
    "test_gateway_discovery"
    "test_async_discovery"
    "test_gateway"
    "test_async"
    "test_asyncio_gateway_discovery"
  ];

  pythonImportsCheck = [
    "screenlogicpy"
  ];

  meta = with lib; {
    description = "Python interface for Pentair Screenlogic devices";
    homepage = "https://github.com/dieselrabbit/screenlogicpy";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
