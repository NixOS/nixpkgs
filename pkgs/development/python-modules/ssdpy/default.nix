{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  pytest-mock,
}:

buildPythonPackage rec {
  pname = "ssdpy";
  version = "0.4.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "MoshiBin";
    repo = "ssdpy";
    rev = version;
    hash = "sha256-luOanw4aOepGxoGtmnWZosq9JyHLJb3E+25tPkkL1w0=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
  ];

  pythonImportsCheck = [ "ssdpy" ];

  disabledTests = [
    # They all require network access
    "test_client_json_output"
    "test_discover"
    "test_server_ipv4"
    "test_server_ipv6"
    "test_server_binds_iface"
    "test_server_bind_address_ipv6"
    "test_server_extra_fields"
  ];

  meta = with lib; {
    changelog = "https://github.com/MoshiBin/ssdpy/releases/tag/${version}";
    description = "A lightweight, compatible SSDP library for Python";
    homepage = "https://github.com/MoshiBin/ssdpy";
    license = licenses.mit;
    maintainers = with maintainers; [ mjm ];
  };
}
