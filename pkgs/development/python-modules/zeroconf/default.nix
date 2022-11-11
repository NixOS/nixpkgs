{ lib
, stdenv
, async-timeout
, buildPythonPackage
, fetchFromGitHub
, ifaddr
, pytest-asyncio
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "zeroconf";
  version = "0.39.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jstasiak";
    repo = "python-zeroconf";
    rev = "refs/tags/${version}";
    hash = "sha256-CUHpTtCQBuuy8E8bjxfhGOIKr9n2Gdhg/RIyv6OWGvI=";
  };

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
    description = "Python implementation of multicast DNS service discovery";
    homepage = "https://github.com/jstasiak/python-zeroconf";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ abbradar ];
  };
}
