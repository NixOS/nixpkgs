{
  lib,
  cython,
  async-timeout,
  buildPythonPackage,
  fetchFromGitHub,
  ifaddr,
  poetry-core,
  pytest-asyncio,
  pytest-codspeed,
  pytest-cov-stub,
  pytest-timeout,
  pythonOlder,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "zeroconf";
  version = "0.147.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "jstasiak";
    repo = "python-zeroconf";
    tag = version;
    hash = "sha256-t1++u+2+Pe/61MXzq5+9ayVl7ot3RrJUGCTNtHicpF8=";
  };

  build-system = [
    cython
    poetry-core
    setuptools
  ];

  dependencies = [ ifaddr ] ++ lib.optionals (pythonOlder "3.11") [ async-timeout ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-codspeed
    pytest-cov-stub
    pytest-timeout
    pytestCheckHook
  ];

  disabledTests = [
    # OSError: [Errno 19] No such device
    "test_close_multiple_times"
    "test_integration_with_listener_ipv6"
    "test_launch_and_close"
    "test_launch_and_close_context_manager"
    "test_launch_and_close_v4_v6"
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [
    "zeroconf"
    "zeroconf.asyncio"
  ];

  meta = with lib; {
    description = "Python implementation of multicast DNS service discovery";
    homepage = "https://github.com/python-zeroconf/python-zeroconf";
    changelog = "https://github.com/python-zeroconf/python-zeroconf/blob/${src.tag}/CHANGELOG.md";
    license = licenses.lgpl21Only;
    maintainers = [ ];
  };
}
