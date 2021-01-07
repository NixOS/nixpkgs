{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, ifaddr
, typing
, isPy27
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "zeroconf";
  version = "0.28.6";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "70f10f0f16e3a8c4eb5e1a106b812b8d052253041cf1ee1195933df706f5261c";
  };

  propagatedBuildInputs = [ ifaddr ]
    ++ lib.optionals (pythonOlder "3.5") [ typing ];

  checkInputs = [ pytestCheckHook ];
  pytestFlagsArray = [ "zeroconf/test.py" ];
  disabledTests = [
    # disable tests that expect some sort of networking in the build container
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
    description = "A pure python implementation of multicast DNS service discovery";
    homepage = "https://github.com/jstasiak/python-zeroconf";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ abbradar ];
  };
}
