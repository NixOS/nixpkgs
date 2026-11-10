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
  version = "0.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cademirch";
    repo = "snakemake-logger-plugin-rich";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zOjidIhGpK9RG9gkxQnR316n8VFyXAm5Luh6QdAlkpg=";
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
