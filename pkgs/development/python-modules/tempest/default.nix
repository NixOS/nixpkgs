{
  lib,
  buildPythonPackage,
  defusedxml,
  fetchPypi,
  pbr,
  cliff,
  jsonschema,
  testtools,
  paramiko,
  netaddr,
  oslo-concurrency,
  oslo-config,
  oslo-log,
  stestr,
  oslo-serialization,
  oslo-utils,
  fixtures,
  pythonOlder,
  pyyaml,
  subunit,
  stevedore,
  prettytable,
  urllib3,
  debtcollector,
  hacking,
  oslotest,
  bash,
  python,
  setuptools,
  testscenarios,
}:

buildPythonPackage rec {
  pname = "tempest";
  version = "40.0.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-s2EvD1TDoRoKrvpRc6h3P7xRyT941nW1hveucXDLB4w=";
  };

  pythonRelaxDeps = [ "defusedxml" ];

  build-system = [ setuptools ];

  dependencies = [
    pbr
    cliff
    defusedxml
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
    testscenarios
  ];

  nativeCheckInputs = [
    stestr
    hacking
    oslotest
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
    description = "OpenStack integration test suite that runs against live OpenStack cluster and validates an OpenStack deployment";
    homepage = "https://github.com/openstack/tempest";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
