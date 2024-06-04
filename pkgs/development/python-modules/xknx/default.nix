{
  lib,
  async-timeout,
  buildPythonPackage,
  fetchFromGitHub,
  cryptography,
  ifaddr,
  pytest-asyncio_0_21,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "xknx";
  version = "2.12.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "XKNX";
    repo = "xknx";
    rev = "refs/tags/${version}";
    hash = "sha256-gajxXIR3lmHsW7258v4z20RilzGfm5KGVrXZwRm74Mk=";
  };

  patches = [ ./pytest-asyncio-0.22-compat.patch ];

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    cryptography
    ifaddr
  ] ++ lib.optionals (pythonOlder "3.11") [ async-timeout ];

  nativeCheckInputs = [
    pytest-asyncio_0_21
    pytestCheckHook
  ];

  pythonImportsCheck = [ "xknx" ];

  disabledTests = [
    # Test requires network access
    "test_scan_timeout"
    "test_start_secure_routing_knx_keys"
    "test_start_secure_routing_manual"
    # RuntimeError: Event loop is closed
    "test_has_group_address_localtime"
    "test_invalid_authentication"
    "test_invalid_frames"
    "test_no_authentication"
    "test_process_read_localtime"
    "test_sync_date"
    "test_sync_datetime"
    "test_sync_time_local"
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
