{ lib
, fetchFromGitHub
, python3Packages
, nixosTests
}:

python3Packages.buildPythonApplication rec {
  pname = "faucet";
  version = "1.10.3";

  src = fetchFromGitHub {
    owner = "faucetsdn";
    repo = "faucet";
    rev = version;
    sha256 = "sha256-sG7YvEr5/SoEmghdw+7bKWR/Ci8ktUhDnnyhHQbI2GY=";
  };

  # We are installing from a tarball, so pbr will not be able to derive versioning.
  PBR_VERSION = version;

  propagatedBuildInputs = with python3Packages; [
    pbr
    pytricia
    ruamel-yaml
    prometheus-client
    networkx
    influxdb
    beka
    chewie
    os-ken
  ];

  checkInputs = with python3Packages; [
    pytestCheckHook
    bitstring
    mininet-python
    netifaces
  ];

  pytestFlagsArray = [
    "--ignore=tests/integration"
    "--ignore=tests/generative/integration"
    "--ignore=tests/generative/fuzzer"
    "--ignore=tests/unit/packaging/test_packaging.py"
    "--ignore=clib/"
    "--ignore=adapters/vendors/rabbitmq/test_rabbit.py"
    "--ignore=tests/unit/gauge/test_main.py"
  ];

  # passthru.tests.faucet = nixosTests.faucet;

  meta = with lib; {
    description = "OpenFlow controller for multi-table OpenFlow ≥ 1.3 switches";
    longDescription = "OpenFlow controller for multi-table OpenFlow ≥ 1.3 switches that supports L2 switching, VLANs ACLs, L3 IPv(4|6) routing: static and via BGP.";
    homepage = "https://github.com/faucetsdn/faucet";
    license = licenses.asl20;
    changelog = "https://github.com/faucetsdn/faucet/releases/tag/${version}";
    maintainers = with maintainers; [ raitobezarius ];
  };
}
