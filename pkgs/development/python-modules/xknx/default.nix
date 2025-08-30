{
  lib,
  async-timeout,
  buildPythonPackage,
  fetchFromGitHub,
  cryptography,
  ifaddr,
  freezegun,
  pytest-asyncio_0,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "xknx";
  version = "3.9.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "XKNX";
    repo = "xknx";
    tag = version;
    hash = "sha256-68Vt5jwtEND2Ej6JP10Rp+kqYc2qu9XbmgZgPOmkWWw=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cryptography
    ifaddr
  ]
  ++ lib.optionals (pythonOlder "3.11") [ async-timeout ];

  nativeCheckInputs = [
    freezegun
    pytest-asyncio_0
    pytestCheckHook
  ];

  pythonImportsCheck = [ "xknx" ];

  disabledTests = [
    # Test requires network access
    "test_routing_indication_multicast"
    "test_scan_timeout"
    "test_start_secure_routing_explicit_keyring"
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
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    platforms = platforms.linux;
  };
}
