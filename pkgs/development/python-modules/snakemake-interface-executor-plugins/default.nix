{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  argparse-dataclass,
  snakemake-interface-common,
  throttler,

  # tests
  pytestCheckHook,
  snakemake-executor-plugin-cluster-generic,

  # passthru
  snakemake-interface-executor-plugins,
}:

buildPythonPackage (finalAttrs: {
  pname = "snakemake-interface-executor-plugins";
  version = "9.4.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "snakemake";
    repo = "snakemake-interface-executor-plugins";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ePbdHMYB2LfCOglz87ZnsUkJH7B97hhSmNBGzwtl5OM=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    argparse-dataclass
    snakemake-interface-common
    throttler
  ];

  pythonImportsCheck = [ "snakemake_interface_executor_plugins" ];

  nativeCheckInputs = [
    pytestCheckHook
    snakemake-executor-plugin-cluster-generic
  ];

  enabledTestPaths = [ "tests/tests.py" ];

  # Circular dependency with snakemake
  doCheck = false;
  passthru.tests.pytest = snakemake-interface-executor-plugins.overridePythonAttrs {
    doCheck = true;
  };

  meta = {
    description = "Stable interface for interactions between Snakemake and its executor plugins";
    homepage = "https://github.com/snakemake/snakemake-interface-executor-plugins";
    changelog = "https://github.com/snakemake/snakemake-interface-executor-plugins/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ veprbl ];
  };
})
