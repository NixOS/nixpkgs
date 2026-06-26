{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  pydantic,
  rich,
  snakemake-interface-executor-plugins,
  snakemake-interface-logger-plugins,

  # tests
  pytestCheckHook,
  snakemake,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "snakemake-logger-plugin-rich";
  version = "0.4.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "cademirch";
    repo = "snakemake-logger-plugin-rich";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vdPM1nRovZ5QhKudzCebMNMndzOWPvTmI5I1oTbzg9o=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    pydantic
    rich
    snakemake-interface-executor-plugins
    snakemake-interface-logger-plugins
  ];

  pythonImportsCheck = [ "snakemake_logger_plugin_rich" ];

  nativeCheckInputs = [
    pytestCheckHook
    snakemake
    writableTmpDirAsHomeHook
  ];

  meta = {
    description = "Snakemake logger plugin using Rich";
    homepage = "https://github.com/cademirch/snakemake-logger-plugin-rich";
    changelog = "https://github.com/cademirch/snakemake-logger-plugin-rich/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
