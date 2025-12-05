{
  lib,
  bash,
  buildPythonPackage,
  cliff,
  debtcollector,
  defusedxml,
  fetchPypi,
  fixtures,
  hacking,
  jsonschema,
  netaddr,
  oslo-concurrency,
  oslo-config,
  oslo-log,
  oslo-serialization,
  oslo-utils,
  oslotest,
  paramiko,
  pbr,
  prettytable,
  python,
  pythonOlder,
  pyyaml,
  setuptools,
  stestr,
  stevedore,
  subunit,
  testscenarios,
  testtools,
  urllib3,
}:

buildPythonPackage rec {
  pname = "tempest";
  version = "46.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ddm1OE7BDwDM4T9GIB0+qK8WvU/+aC+FBIGWDm3ObHM=";
  };

  pythonRelaxDeps = [ "defusedxml" ];

  build-system = [ setuptools ];

  dependencies = [
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
    testscenarios
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
      tempest.tests.cmd.test_cleanup.TestTempestCleanup.test_load_json_resource_list
      tempest.tests.cmd.test_cleanup.TestTempestCleanup.test_load_json_saved_state
      tempest.tests.cmd.test_cleanup.TestTempestCleanup.test_take_action_got_exception
      tempest.tests.lib.cli.test_execute.TestExecute.test_execute_with_prefix
    ")
  '';

  pythonImportsCheck = [ "tempest" ];

  meta = with lib; {
    description = "OpenStack integration test suite that runs against live OpenStack cluster and validates an OpenStack deployment";
    homepage = "https://github.com/openstack/tempest";
    license = licenses.asl20;
    mainProgram = "tempest";
    teams = [ teams.openstack ];
  };
}
