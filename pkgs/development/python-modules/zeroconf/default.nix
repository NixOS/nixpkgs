{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, ifaddr
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "zeroconf";
  version = "0.31.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-U6GAJIRxxvgb0f/8vOA+2T19jq8QkFyRIaweqZbRmEQ=";
  };

  propagatedBuildInputs = [ ifaddr ];

  checkInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "zeroconf/test.py" ];

  disabledTests = [
    # disable tests that expect some sort of networking in the build container
    "test_close_multiple_times"
    "test_launch_and_close"
    "test_launch_and_close_v4_v6"
    "test_launch_and_close_v6_only"
    "test_integration_with_listener_ipv6"
  ] ++ lib.optionals stdenv.isDarwin [
    "test_lots_of_names"
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "zeroconf" ];

  meta = with lib; {
    description = "Python implementation of multicast DNS service discovery";
    homepage = "https://github.com/jstasiak/python-zeroconf";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ abbradar ];
  };
}
