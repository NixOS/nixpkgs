{ lib
, bash
, buildPythonPackage
, cliff
, debtcollector
, defusedxml
, fetchPypi
, fixtures
, hacking
, jsonschema
, netaddr
, oslo-concurrency
, oslo-config
, oslo-log
, oslo-serialization
, oslo-utils
, oslotest
, paramiko
, pbr
, prettytable
, python
, pythonOlder
, pyyaml
, stestr
, stevedore
, subunit
, testtools
, urllib3
}:

buildPythonPackage rec {
  pname = "tempest";
  version = "33.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-aEtBAE3p+HVw/macwZtKo20mSJctrsIN7idqWe6Dvtc=";
  };

  propagatedBuildInputs = [
    cliff
    debtcollector
    defusedxml
    fixtures
    jsonschema
    netaddr
    oslo-concurrency
    oslo-config
    oslo-log
    oslo-serialization
    oslo-utils
    paramiko
    pbr
    prettytable
    pyyaml
    stestr
    stevedore
    subunit
    testtools
    urllib3
  ];

  nativeCheckInputs = [
    hacking
    oslotest
    stestr
  ];

  checkPhase = ''
    # Tests expect these applications available as such.
    mkdir -p bin
    export PATH="$PWD/bin:$PATH"
    printf '#!${bash}/bin/bash\nexec ${python.interpreter} -m tempest.cmd.main "$@"\n' > bin/tempest
    printf '#!${bash}/bin/bash\nexec ${python.interpreter} -m tempest.cmd.subunit_describe_calls "$@"\n' > bin/subunit-describe-calls
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
