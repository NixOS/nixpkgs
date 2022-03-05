{ lib
, buildPythonApplication
, fetchPypi
, fetchpatch
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
, hacking
, oslotest
, bash
, python3
}:

buildPythonApplication rec {
  pname = "tempest";
  version = "29.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0521d3042360c0fb469b16f99174a9abddbae8a2d2a81268cfc664f1ccfdd0f9";
  };

  patches = [
    # remove need for unittest2
    (fetchpatch {
      url = "https://github.com/openstack/tempest/commit/cd3745c27b7d8fcdaffc72b965a3d803d9ee12c2.patch";
      sha256 = "sha256-UwUmyFZokH66Xqfsj982MBHb0w7x6v4SAtXlqA5dpnk=";
    })
  ];

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
