{ lib
, async-timeout
, buildPythonPackage
, fetchFromGitHub
, pythonAtLeast
, pythonOlder
, pytest-asyncio
, setuptools
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "screenlogicpy";
  version = "0.10.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "dieselrabbit";
    repo = "screenlogicpy";
    rev = "refs/tags/v${version}";
    hash = "sha256-z6cM0sihZvOHCA3v1DYQEev0axf4AcqEW13WA1EMhQM=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    async-timeout
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    # Tests require network access
    "test_async_discovery"
    "test_async"
    "test_asyncio_gateway_discovery"
    "test_discovery_async_discover"
    "test_gateway_discovery"
    "test_gateway"
  ] ++ lib.optionals (pythonAtLeast "3.12") [
    # Tests block on Python 3.12
    "test_sub_unsub"
    "test_attach_existing"
    "test_login_async_connect_to_gateway"
    "test_login_async_gateway_connect"
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
