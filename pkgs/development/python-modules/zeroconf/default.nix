{ lib
, stdenv
, async-timeout
, buildPythonPackage
, fetchFromGitHub
, ifaddr
, poetry-core
, pytest-asyncio
, pythonOlder
, pytestCheckHook
, setuptools
}:

buildPythonPackage rec {
  pname = "zeroconf";
  version = "0.47.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jstasiak";
    repo = "python-zeroconf";
    rev = "refs/tags/${version}";
    hash = "sha256-vY4n0QIEzumtUayRbGGqycR3z7kpbOH4XKxSMcnTVrA=";
  };

  nativeBuildInputs = [
    poetry-core
    setuptools
  ];

  propagatedBuildInputs = [
    async-timeout
    ifaddr
  ];

  # OSError: [Errno 48] Address already in use
  doCheck = !stdenv.isDarwin;

  checkInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  preCheck = ''
    sed -i '/addopts/d' pyproject.toml
  '';

  disabledTests = [
    # tests that require network interaction
    "test_close_multiple_times"
    "test_launch_and_close"
    "test_launch_and_close_context_manager"
    "test_launch_and_close_v4_v6"
    "test_launch_and_close_v6_only"
    "test_integration_with_listener_ipv6"
    # Starting with 0.39.0: AssertionError: assert [('add', '_ht..._tcp.local.')]
    "test_service_browser_expire_callbacks"
  ] ++ lib.optionals stdenv.isDarwin [
    "test_lots_of_names"
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [
    "zeroconf"
    "zeroconf.asyncio"
  ];

  meta = with lib; {
    changelog = "https://github.com/python-zeroconf/python-zeroconf/releases/tag/${version}";
    description = "Python implementation of multicast DNS service discovery";
    homepage = "https://github.com/jstasiak/python-zeroconf";
    changelog = "https://github.com/python-zeroconf/python-zeroconf/blob/${version}/CHANGELOG.md";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ abbradar ];
  };
}
