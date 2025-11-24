{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cryptography,
  ifaddr,
  freezegun,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "xknx";
  version = "3.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "XKNX";
    repo = "xknx";
    tag = version;
    hash = "sha256-jWnDiGg7vjIt4xkqjKrauExnvHcrH8m0RGfHjQlljFY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cryptography
    ifaddr
  ];

  nativeCheckInputs = [
    freezegun
    pytest-asyncio
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
  ];

  meta = with lib; {
    description = "KNX Library Written in Python";
    longDescription = ''
      XKNX is an asynchronous Python library for reading and writing KNX/IP
      packets. It provides support for KNX/IP routing and tunneling devices.
    '';
    homepage = "https://github.com/XKNX/xknx";
    changelog = "https://github.com/XKNX/xknx/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    platforms = platforms.linux;
  };
}
