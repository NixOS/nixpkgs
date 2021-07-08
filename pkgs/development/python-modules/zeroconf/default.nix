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
  version = "0.32.1";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  # no tests in pypi sdist
  src = fetchFromGitHub {
    owner = "jstasiak";
    repo = "python-zeroconf";
    rev = version;
    sha256 = "02fvh5ii73rf6pg9x93pc0sl1isx2ivg3d80l6s8h35w2f4g4azf";
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
