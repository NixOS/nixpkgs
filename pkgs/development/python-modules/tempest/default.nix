{ lib
, buildPythonApplication
, fetchPypi
, pbr
, cliff
, jsonschema
, testtools
, paramiko
, netaddr
, oslo-concurrency
, oslo-config
, oslo-log
, stestr
, oslo-serialization
, oslo-utils
, fixtures
, pyyaml
, subunit
, stevedore
, prettytable
, urllib3
, debtcollector
, unittest2
, hacking
, oslotest
, bash
, python3
}:

buildPythonApplication rec {
  pname = "tempest";
  version = "29.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2045963560f91241c56940af741f081e59212c65c9867dfcdabfe07f9dd4d255";
  };

  propagatedBuildInputs = [
    pbr
    cliff
    jsonschema
    testtools
    paramiko
    netaddr
    oslo-concurrency
    oslo-config
    oslo-log
    stestr
    oslo-serialization
    oslo-utils
    fixtures
    pyyaml
    subunit
    stevedore
    prettytable
    urllib3
    debtcollector
    unittest2
  ];

  checkInputs = [
    stestr
    hacking
    oslotest
  ];

  checkPhase = ''
    # Tests expect these applications available as such.
    mkdir -p bin
    export PATH="$PWD/bin:$PATH"
    printf '#!${bash}/bin/bash\nexec ${python3.interpreter} -m tempest.cmd.main "$@"\n' > bin/tempest
    printf '#!${bash}/bin/bash\nexec ${python3.interpreter} -m tempest.cmd.subunit_describe_calls "$@"\n' > bin/subunit-describe-calls
    chmod +x bin/*

    stestr --test-path tempest/tests run -e <(echo "
      tempest.tests.lib.cli.test_execute.TestExecute.test_execute_with_prefix
    ")
  '';

  pythonImportsCheck = [ "tempest" ];

  meta = with lib; {
    description = "An OpenStack integration test suite that runs against live OpenStack cluster and validates an OpenStack deployment";
    homepage = "https://github.com/openstack/tempest";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
