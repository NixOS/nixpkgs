{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  snakemake-interface-common,

  # tests
  pytestCheckHook,
  snakemake-logger-plugin-rich,

  # passthru
  snakemake-interface-logger-plugins,
}:

buildPythonPackage (finalAttrs: {
  pname = "snakemake-interface-logger-plugins";
  version = "2.0.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "snakemake";
    repo = "snakemake-interface-logger-plugins";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yvEjd4xBjjCocGK/HD1j5jcuy+syyXcEJGdsEFA0H40=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    snakemake-interface-common
  ];

  pythonImportsCheck = [ "snakemake_interface_logger_plugins" ];

  nativeCheckInputs = [
    pytestCheckHook
    snakemake-logger-plugin-rich
  ];

  enabledTestPaths = [ "tests/tests.py" ];

  # Circular dependency with snakemake
  doCheck = false;
  passthru.tests.pytest = snakemake-interface-logger-plugins.overridePythonAttrs {
    doCheck = true;
  };

  meta = {
    description = "Stable interface for interactions between Snakemake and its logger plugins";
    homepage = "https://github.com/snakemake/snakemake-interface-logger-plugins";
    changelog = "https://github.com/snakemake/snakemake-interface-logger-plugins/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ veprbl ];
  };
})
