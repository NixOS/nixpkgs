{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  snakemake-interface-common,

  # tests
  pytestCheckHook,
  snakemake,

  # passthru
  snakemake-interface-report-plugins,
}:

buildPythonPackage (finalAttrs: {
  pname = "snakemake-interface-report-plugins";
  version = "1.3.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "snakemake";
    repo = "snakemake-interface-report-plugins";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3ugEmdO1dcusKXXBZBRszlZXX5fhJyYSSF5Uj5CKJkQ=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    snakemake-interface-common
  ];

  pythonImportsCheck = [ "snakemake_interface_report_plugins" ];

  nativeCheckInputs = [
    pytestCheckHook
    snakemake
  ];

  enabledTestPaths = [ "tests/tests.py" ];

  # Circular dependency with snakemake
  doCheck = false;
  passthru.tests.pytest = snakemake-interface-report-plugins.overridePythonAttrs {
    doCheck = true;
  };

  meta = {
    description = "Interface for Snakemake report plugins";
    homepage = "https://github.com/snakemake/snakemake-interface-report-plugins";
    changelog = "https://github.com/snakemake/snakemake-interface-report-plugins/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ veprbl ];
  };
})
