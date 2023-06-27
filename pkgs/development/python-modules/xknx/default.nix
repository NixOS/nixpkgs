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
}:

buildPythonPackage rec {
  pname = "xknx";
  version = "2.11.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "XKNX";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-9H5LQX6uXWr9pQ/WosNl1LrcbR+MAwVtZv8Cdb+WFvg=";
  };

  nativeBuildInputs = [
    setuptools
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
