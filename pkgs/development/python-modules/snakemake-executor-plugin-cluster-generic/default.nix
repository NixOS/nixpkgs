{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  snakemake-interface-common,
  snakemake-interface-executor-plugins,

  # tests
  pytestCheckHook,
  snakemake,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "snakemake-executor-plugin-cluster-generic";
  version = "1.0.9";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "snakemake";
    repo = "snakemake-executor-plugin-cluster-generic";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RHMefoJOZb6TjRsFCORLFdHtI5ZpTsV6CHrjHKMat9o=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    snakemake-interface-common
    snakemake-interface-executor-plugins
  ];

  pythonImportsCheck = [ "snakemake_executor_plugin_cluster_generic" ];

  nativeCheckInputs = [
    pytestCheckHook
    snakemake
    writableTmpDirAsHomeHook
  ];

  enabledTestPaths = [ "tests/tests.py" ];

  disabledTestPaths = [
    # Failed to setup log file: [Errno 13] Permission denied: '/build/pytest-of-nixbld/pytest-0/test_group_workflow5/groups/.snakemake'
    "tests/tests.py::TestWorkflowsCancelCmd::test_group_workflow"
    "tests/tests.py::TestWorkflowsCancelCmd::test_simple_workflow"
    "tests/tests.py::TestWorkflowsSidecar::test_group_workflow"
    "tests/tests.py::TestWorkflowsSidecar::test_simple_workflow"
    "tests/tests.py::TestWorkflowsStatusCmd::test_group_workflow"
    "tests/tests.py::TestWorkflowsStatusCmd::test_simple_workflow"
    "tests/tests.py::TestWorkflowsSubmitCmdOnly::test_group_workflow"
    "tests/tests.py::TestWorkflowsSubmitCmdOnly::test_simple_workflow"
  ];

  meta = {
    description = "Generic cluster executor for Snakemake";
    homepage = "https://github.com/snakemake/snakemake-executor-plugin-cluster-generic";
    changelog = "https://github.com/snakemake/snakemake-executor-plugin-cluster-generic/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ veprbl ];
  };
})
