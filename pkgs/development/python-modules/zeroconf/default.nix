{ lib
, stdenv
, cython
, async-timeout
, buildPythonPackage
, fetchFromGitHub
, ifaddr
, poetry-core
, pytest-asyncio
, pytest-timeout
, pythonOlder
, pytestCheckHook
, setuptools
}:

buildPythonPackage rec {
  pname = "zeroconf";
  version = "0.120.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jstasiak";
    repo = "python-zeroconf";
    rev = "refs/tags/${version}";
    hash = "sha256-z1hAADRlbcl0Di8QEKmE1sAYn1iEES3Q56Wb2C7mYtA=";
  };

  nativeBuildInputs = [
    cython
    poetry-core
    setuptools
  ];

  propagatedBuildInputs = [
    ifaddr
  ] ++ lib.optionals (pythonOlder "3.11") [
    async-timeout
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-timeout
    pytestCheckHook
  ];

  preCheck = ''
    sed -i '/addopts/d' pyproject.toml
  '';

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
    changelog = "https://github.com/python-zeroconf/python-zeroconf/releases/tag/${version}";
    description = "Python implementation of multicast DNS service discovery";
    homepage = "https://github.com/python-zeroconf/python-zeroconf";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ abbradar ];
  };
}
