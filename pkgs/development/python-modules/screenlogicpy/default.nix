{ lib
, async-timeout
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "screenlogicpy";
  version = "0.6.3";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "dieselrabbit";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-AWQiOTgYYqhsaJqYMwhCBoSWJ1ol6dJc6TArqptNu6Y=";
  };

  propagatedBuildInputs = [
    async-timeout
  ];

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
    changelog = "https://github.com/dieselrabbit/screenlogicpy/releases/tag/v${version}";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
