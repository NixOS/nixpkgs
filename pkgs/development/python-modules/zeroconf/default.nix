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
  version = "0.28.2";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "447d6da0b6426c0c67d5c29339e51b2d75e2c1f129605ad35a0cb84a454f09bc";
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
