{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, ifaddr
, pytest-asyncio
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "zeroconf";
  version = "0.36.9";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  # no tests in pypi sdist
  src = fetchFromGitHub {
    owner = "jstasiak";
    repo = "python-zeroconf";
    rev = version;
    sha256 = "sha256-V2AiKmL3laA6Kd2lOXZ7f+7L08zMtDfvhLxayylp1CQ=";
  };

  propagatedBuildInputs = [
    ifaddr
  ];

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
