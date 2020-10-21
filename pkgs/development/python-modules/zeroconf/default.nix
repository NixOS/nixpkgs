{ lib
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
  version = "0.28.5";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "c08dbb90c116626cb6c5f19ebd14cd4846cffe7151f338c19215e6938d334980";
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
  ];

  pythonImportsCheck = [ "zeroconf" ];

  meta = with lib; {
    description = "A pure python implementation of multicast DNS service discovery";
    homepage = "https://github.com/jstasiak/python-zeroconf";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ abbradar ];
  };
}
