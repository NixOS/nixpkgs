{
  lib,
  cython,
  buildPythonPackage,
  fetchFromGitHub,
  ifaddr,
  poetry-core,
  pytest-asyncio,
  pytest-codspeed,
  pytest-cov-stub,
  pytest-timeout,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "zeroconf";
  version = "0.151.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jstasiak";
    repo = "python-zeroconf";
    tag = finalAttrs.version;
    hash = "sha256-iMWlTX+GnJ7A2roh5aryoEf+9+963W2i4HVjtb5I00Q=";
  };

  build-system = [
    cython
    poetry-core
    setuptools
  ];

  dependencies = [ ifaddr ];

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
    "test_context_manager_marks_done"
    "test_default_interface_warns_when_ipv6_requested"
    "test_open_and_close_cleanly"
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

  meta = {
    description = "Python implementation of multicast DNS service discovery";
    homepage = "https://github.com/python-zeroconf/python-zeroconf";
    changelog = "https://github.com/python-zeroconf/python-zeroconf/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.lgpl21Only;
    maintainers = [ ];
  };
})
