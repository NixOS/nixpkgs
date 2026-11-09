{
  lib,
  bash,
  buildPythonPackage,
  cliff,
  debtcollector,
  defusedxml,
  fetchFromGitHub,
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
  pyyaml,
  setuptools,
  stestr,
  stestrCheckHook,
  stevedore,
  python-subunit,
  testscenarios,
  testtools,
  urllib3,
}:

buildPythonPackage (finalAttrs: {
  pname = "tempest";
  version = "47.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "tempest";
    tag = finalAttrs.version;
    hash = "sha256-ovEVWiJs1tbdHv1y3l9lcHoPKBszpPfDtamz06RFfxY=";
  };

  # Manually set version since pbr wants to get it from git (not in a tarball)
  env.PBR_VERSION = finalAttrs.version;

  postPatch = ''
    # pbr needs git to ship subpackages and package data
    echo "recursive-include tempest *" > MANIFEST.in

    substituteInPlace tempest/lib/common/http.py \
      --replace-fail 'getheaders()' 'headers'
  '';

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
    python-subunit
    testscenarios
    testtools
    urllib3
  ];

  nativeCheckInputs = [
    hacking
    oslotest
    stestrCheckHook
  ];

  preCheck = ''
    # Tests expect these applications available as such.
    mkdir -p bin
    export PATH="$PWD/bin:$PATH"
    printf '#!${bash}/bin/bash\nexec ${python.interpreter} -m tempest.cmd.main "$@"\n' > bin/tempest
    printf '#!${bash}/bin/bash\nexec ${python.interpreter} -m tempest.cmd.subunit_describe_calls "$@"\n' > bin/subunit-describe-calls
    chmod +x bin/*
  '';

  stestrFlags = [
    "--test-path"
    "tempest/tests"
  ];

  disabledTests = [
    "tempest.tests.common.test_concurrency.TestConcurrency.test_run_concurrent_tasks_dict_return_values"
    "tempest.tests.common.test_concurrency.TestConcurrency.test_run_concurrent_tasks_multiple_workers"
    "tempest.tests.common.test_concurrency.TestConcurrency.test_run_concurrent_tasks_single_process"
    "tempest.tests.common.test_concurrency.TestConcurrency.test_run_concurrent_tasks_success"
    "tempest.tests.common.test_concurrency.TestConcurrency.test_run_concurrent_tasks_with_exception"
    "tempest.tests.lib.cli.test_execute.TestExecute.test_execute_with_prefix"
    "tempest.tests.lib.common.test_rest_client.TestRestClientServiceToken.test_log_request_full_omits_service_token"
    # requires network access
    "tempest.tests.common.test_image.TestRandomDataServer.test_binds_non_loopback_host"
  ];

  pythonImportsCheck = [
    "tempest"
    "tempest.lib.services.compute"
  ];

  meta = {
    description = "OpenStack integration test suite that runs against live OpenStack cluster and validates an OpenStack deployment";
    homepage = "https://github.com/openstack/tempest";
    license = lib.licenses.asl20;
    mainProgram = "tempest";
    teams = [ lib.teams.openstack ];
  };
})
