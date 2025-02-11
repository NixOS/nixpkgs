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
  pynacl,
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
  version = "42.0.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-nW6cSOhC56YkyUQiXcJTqaojRseIf9q8YGSe4skhTA4=";
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
    pynacl
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
    description = "OpenStack integration test suite that runs against live OpenStack cluster and validates an OpenStack deployment";
    homepage = "https://github.com/openstack/tempest";
    license = licenses.asl20;
    mainProgram = "tempest";
    maintainers = teams.openstack.members;
  };
}
