{ lib
, async-timeout
, buildPythonPackage
, fetchFromGitHub
, cryptography
, ifaddr
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "xknx";
  version = "2.12.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "XKNX";
    repo = "xknx";
    rev = "refs/tags/${version}";
    hash = "sha256-Fwo76tvkLLx8QJeokuGohhnt83eGBMyWIUSHJGuQWJ4=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    async-timeout
    cryptography
    ifaddr
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "xknx"
  ];

  disabledTests = [
    # Test requires network access
    "test_scan_timeout"
    "test_start_secure_routing_knx_keys"
    "test_start_secure_routing_manual"
  ];

  meta = with lib; {
    description = "KNX Library Written in Python";
    longDescription = ''
      XKNX is an asynchronous Python library for reading and writing KNX/IP
      packets. It provides support for KNX/IP routing and tunneling devices.
    '';
    homepage = "https://github.com/XKNX/xknx";
    changelog = "https://github.com/XKNX/xknx/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    platforms = platforms.linux;
  };
}
